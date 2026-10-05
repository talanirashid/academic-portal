const functions = require("firebase-functions");
const admin = require("firebase-admin");

if (!admin.apps.length) {
  admin.initializeApp();
}
const db = admin.firestore();

/**
 * Normalizes Transaction IDs by stripping spaces and special characters
 */
function cleanTid(raw) {
  if (!raw) return "";
  return String(raw).trim().toUpperCase().replace(/[^A-Z0-9\-_]/g, "");
}

/**
 * Webhook triggered by n8n workflow after parsing SMS from JazzCash / Easypaisa
 */
exports.processAutomatedPaymentWebhook = functions
  .runWith({ timeoutSeconds: 60, memory: "256MB" })
  .https.onRequest(async (req, res) => {
    // Enable CORS
    res.set("Access-Control-Allow-Origin", "*");
    res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
    res.set("Access-Control-Allow-Headers", "Content-Type, Authorization, x-n8n-webhook-secret");

    if (req.method === "OPTIONS") {
      return res.status(204).send("");
    }

    if (req.method !== "POST") {
      return res.status(405).json({ error: "Method Not Allowed" });
    }

    // Verify webhook authorization secret
    const incomingSecret = req.headers["x-n8n-webhook-secret"];
    const configuredSecret = process.env.N8N_WEBHOOK_SECRET || "PCS_SECURE_N8N_SECRET_KEY";

    if (!incomingSecret || incomingSecret !== configuredSecret) {
      console.warn("Unauthorized webhook attempt detected.");
      return res.status(401).json({ error: "Unauthorized: Invalid Webhook Secret" });
    }

    const { tid, amount, senderPhone, provider } = req.body;
    const sanitizedTid = cleanTid(tid);

    if (!sanitizedTid || sanitizedTid.length < 6) {
      return res.status(400).json({ error: "Missing or invalid TID parameter." });
    }

    try {
      // 1. Check for a pending student submission matching this TID
      const pendingQuery = await db.collection("payment_verifications")
        .where("tid", "==", sanitizedTid)
        .where("status", "==", "pending")
        .limit(1)
        .get();

      if (pendingQuery.empty) {
        // Log in unclaimed_deposits ledger for audit
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
          message: `TID ${sanitizedTid} recorded in unclaimed ledger. No pending student match found.`,
        });
      }

      // 2. Matching student record found: Run atomic pass minting
      const verificationDoc = pendingQuery.docs[0];
      const verifyData = verificationDoc.data();
      const studentUid = verifyData.uid;
      const boardId = verifyData.boardId;
      const targetGrade = verifyData.targetGrade;

      const batch = db.batch();

      // Approve verification document
      batch.update(verificationDoc.ref, {
        status: "approved",
        automatedVia: "n8n_sms_engine",
        matchedAmount: Number(amount) || 0.0,
        approvedAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Grant active pass in student profile
      const passDocRef = db.collection("users")
        .doc(studentUid)
        .collection("active_passes")
        .doc(`${boardId}_${targetGrade}`);

      batch.set(passDocRef, {
        passId: `${boardId}_${targetGrade}`,
        boardId: boardId,
        targetGrade: targetGrade,
        isActive: true,
        grantedBy: "SYSTEM_N8N_AUTOMATION",
        activatedAt: admin.firestore.FieldValue.serverTimestamp(),
        expiresAt: null, // Perpetual session or configured expiration date
      }, { merge: true });

      await batch.commit();

      console.log(`Payment pass granted to ${studentUid} for ${boardId}_${targetGrade}`);
      return res.status(200).json({
        success: true,
        message: `Pass granted to student ${studentUid} for ${boardId} ${targetGrade}`,
      });
    } catch (err) {
      console.error("Webhook Execution Error:", err);
      return res.status(500).json({ error: "Internal processing error", details: err.message });
    }
  });
