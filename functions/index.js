const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { google } = require("googleapis");
const path = require("path");
const fs = require("fs");

if (!admin.apps.length) {
  admin.initializeApp();
}
const db = admin.firestore();

function cleanTid(raw) {
  if (!raw) return "";
  return String(raw).trim().toUpperCase().replace(/[^A-Z0-9\-_]/g, "");
}

/**
 * 1. ZERO-TRUST ENROLLMENT REQUEST SUBMISSION
 */
exports.submitEnrollmentRequest = functions.https.onCall(async (data, context) => {
  if (!context.auth || !context.auth.uid) {
    throw new functions.https.HttpsError("unauthenticated", "Login required to submit enrollment.");
  }

  const uid = context.auth.uid;
  const { packageId, packageName, amount, paymentMethod, transactionId, senderPhoneNumber } = data;

  if (!transactionId || String(transactionId).trim().length < 6) {
    throw new functions.https.HttpsError("invalid-argument", "Valid Transaction ID (TID) is required.");
  }

  // Fetch verified user profile
  const userDoc = await db.collection("users").doc(uid).get();
  const userProfile = userDoc.exists ? userDoc.data() : {};

  const reqRef = db.collection("enrollment_requests").doc();
  const payload = {
    requestId: reqRef.id,
    studentUid: uid,
    studentName: userProfile.fullName || userProfile.displayName || "Student",
    studentEmail: userProfile.email || context.auth.token.email || "",
    packageId: packageId || "pro_pass",
    packageName: packageName || "Annual Board Exam Pro Pass",
    amount: Number(amount) || 0.0,
    paymentMethod: paymentMethod || "jazzcash",
    transactionId: cleanTid(transactionId),
    senderPhoneNumber: senderPhoneNumber || "",
    status: "pending_verification",
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  await reqRef.set(payload);

  return {
    success: true,
    requestId: reqRef.id,
    message: "Enrollment request submitted successfully.",
  };
});

/**
 * 2. SECURE GOOGLE DRIVE AVATAR UPLOADER
 */
exports.uploadStudentAvatar = functions.https.onCall(async (data, context) => {
  if (!context.auth || !context.auth.uid) {
    throw new functions.https.HttpsError("unauthenticated", "Authentication required for photo upload.");
  }

  const uid = context.auth.uid;
  const { base64Image } = data;

  if (!base64Image) {
    throw new functions.https.HttpsError("invalid-argument", "Base64 image data missing.");
  }

  const MASTER_FOLDER_ID = "1vpIz70_LusjYmSNMObzBQXGeEcK0zhO7";
  const serviceAccountPath = path.resolve(__dirname, "./service-account-key.json");

  let authClient;
  if (fs.existsSync(serviceAccountPath)) {
    const key = require(serviceAccountPath);
    authClient = new google.auth.JWT(
      key.client_email,
      null,
      key.private_key,
      ["https://www.googleapis.com/auth/drive.file", "https://www.googleapis.com/auth/drive"]
    );
  } else {
    authClient = await google.auth.getClient({
      scopes: ["https://www.googleapis.com/auth/drive.file", "https://www.googleapis.com/auth/drive"],
    });
  }

  const drive = google.drive({ version: "v3", auth: authClient });

  // 1. Check or create 'PCSA_Student_Avatars' folder inside master parent folder
  let avatarFolderId = MASTER_FOLDER_ID;
  try {
    const folderRes = await drive.files.list({
      q: `'${MASTER_FOLDER_ID}' in parents and name = 'PCSA_Student_Avatars' and mimeType = 'application/vnd.google-apps.folder' and trashed = false`,
      fields: "files(id, name)",
    });

    if (folderRes.data.files && folderRes.data.files.length > 0) {
      avatarFolderId = folderRes.data.files[0].id;
    } else {
      const createFolderRes = await drive.files.create({
        resource: {
          name: "PCSA_Student_Avatars",
          mimeType: "application/vnd.google-apps.folder",
          parents: [MASTER_FOLDER_ID],
        },
        fields: "id",
      });
      avatarFolderId = createFolderRes.data.id;
    }
  } catch (err) {
    console.warn("Folder check fallback to master folder:", err.message);
  }

  // 2. Decode base64 image buffer
  const cleanBase64 = base64Image.replace(/^data:image\/\w+;base64,/, "");
  const imageBuffer = Buffer.from(cleanBase64, "base64");
  const tempFilePath = path.join("/tmp", `${uid}_avatar.jpg`);
  fs.writeFileSync(tempFilePath, imageBuffer);

  // 3. Upload file to Google Drive
  const fileMetadata = {
    name: `${uid}_avatar.jpg`,
    parents: [avatarFolderId],
  };

  const media = {
    mimeType: "image/jpeg",
    body: fs.createReadStream(tempFilePath),
  };

  const driveFile = await drive.files.create({
    resource: fileMetadata,
    media: media,
    fields: "id, webViewLink",
  });

  const fileId = driveFile.data.id;

  // 4. Set public reader permission
  try {
    await drive.permissions.create({
      fileId: fileId,
      resource: {
        role: "reader",
        type: "anyone",
      },
    });
  } catch (permErr) {
    console.warn("Permission set warning:", permErr.message);
  }

  const avatarUrl = `https://lh3.googleusercontent.com/d/${fileId}`;

  // 5. Update user profile in Firestore
  await db.collection("users").doc(uid).set({
    avatarDriveFileId: fileId,
    avatarUrl: avatarUrl,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  }, { merge: true });

  // Clean up temp file
  if (fs.existsSync(tempFilePath)) fs.unlinkSync(tempFilePath);

  return {
    success: true,
    avatarUrl: avatarUrl,
    fileId: fileId,
  };
});

/**
 * 3. AUTOMATED WEBHOOK INGESTION ENGINE
 */
exports.processAutomatedPaymentWebhook = functions
  .runWith({ timeoutSeconds: 60, memory: "256MB" })
  .https.onRequest(async (req, res) => {
    res.set("Access-Control-Allow-Origin", "*");
    res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
    res.set("Access-Control-Allow-Headers", "Content-Type, Authorization, x-n8n-webhook-secret");

    if (req.method === "OPTIONS") return res.status(204).send("");
    if (req.method !== "POST") return res.status(405).json({ error: "Method Not Allowed" });

    const incomingSecret = req.headers["x-n8n-webhook-secret"];
    const configuredSecret = process.env.N8N_WEBHOOK_SECRET || "PCS_SECURE_N8N_SECRET_KEY";

    if (!incomingSecret || incomingSecret !== configuredSecret) {
      return res.status(401).json({ error: "Unauthorized: Invalid Webhook Secret" });
    }

    const { tid, amount, senderPhone, provider } = req.body;
    const sanitizedTid = cleanTid(tid);

    if (!sanitizedTid || sanitizedTid.length < 6) {
      return res.status(400).json({ error: "Missing or invalid TID parameter." });
    }

    try {
      const pendingQuery = await db.collection("enrollment_requests")
        .where("transactionId", "==", sanitizedTid)
        .where("status", "==", "pending_verification")
        .limit(1)
        .get();

      if (pendingQuery.empty) {
        await db.collection("unclaimed_deposits").doc(sanitizedTid).set({
          tid: sanitizedTid,
          amount: Number(amount) || 0.0,
          senderPhone: senderPhone || null,
          provider: provider || "Unknown",
          loggedAt: admin.firestore.FieldValue.serverTimestamp(),
          resolved: false,
        });

        return res.status(200).json({
          status: "logged_unclaimed",
          message: `TID ${sanitizedTid} recorded in unclaimed ledger.`,
        });
      }

      const reqDoc = pendingQuery.docs[0];
      const reqData = reqDoc.data();

      const batch = db.batch();
      batch.update(reqDoc.ref, {
        status: "approved",
        automatedVia: "n8n_webhook",
        approvedAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      const passRef = db.collection("users")
        .doc(reqData.studentUid)
        .collection("active_passes")
        .doc(reqData.packageId || "pro_pass");

      batch.set(passRef, {
        passId: reqData.packageId || "pro_pass",
        isActive: true,
        grantedBy: "N8N_AUTOMATION",
        activatedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, { merge: true });

      await batch.commit();

      return res.status(200).json({ success: true, message: `Pass granted to ${reqData.studentUid}` });
    } catch (err) {
      return res.status(500).json({ error: err.message });
    }
  });
