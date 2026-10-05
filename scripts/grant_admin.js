/**
 * Run: node scripts/grant_admin.js <admin_email>
 */
const admin = require("firebase-admin");
const path = require("path");

// Expect service account credentials in the root directory
const serviceAccountPath = path.resolve(__dirname, "../serviceAccountKey.json");
let serviceAccount;

try {
  serviceAccount = require(serviceAccountPath);
} catch (e) {
  console.error("ERROR: Place 'serviceAccountKey.json' in the project root to run administrative scripts.");
  process.exit(1);
}

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

async function setAdminPrivileges(targetEmail) {
  try {
    const user = await admin.auth().getUserByEmail(targetEmail);

    // Set custom claims directly in Firebase Auth JWT
    await admin.auth().setCustomUserClaims(user.uid, {
      admin: true,
      role: "admin",
      pcsOperator: true,
    });

    // Mirror to Firestore user document for immediate frontend sync
    await admin.firestore().collection("users").doc(user.uid).set({
      role: "admin",
      email: targetEmail,
      isAdmin: true,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });

    console.log(`SUCCESS: Administrator permissions granted to: ${targetEmail} (UID: ${user.uid})`);
    console.log("NOTE: Have the user log out and log back in on the web app to refresh their Auth JWT token.");
    process.exit(0);
  } catch (error) {
    console.error("Failed to grant admin privileges:", error.message);
    process.exit(1);
  }
}

const emailArg = process.argv[2];
if (!emailArg) {
  console.error("Usage: node scripts/grant_admin.js <target_email>");
  process.exit(1);
}

setAdminPrivileges(emailArg.trim());
