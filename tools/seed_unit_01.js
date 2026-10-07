/**
 * PCSA Academy • Firestore Unit 1 Seed Tool
 * Executable script to seed STBB Class 11 Unit 1 complete bundle into Cloud Firestore.
 *
 * Run: node tools/seed_unit_01.js
 */

const path = require('path');
const fs = require('fs');

// Resolve firebase-admin from functions/node_modules or global node_modules
let admin;
try {
  admin = require(path.resolve(__dirname, '../functions/node_modules/firebase-admin'));
} catch (e) {
  try {
    admin = require('firebase-admin');
  } catch (e2) {
    console.error('ERROR: Could not load firebase-admin. Run npm install in functions/ directory.');
    process.exit(1);
  }
}

// Locate service account credentials
const serviceAccountPath = path.resolve(__dirname, '../functions/service-account-key.json');
const fallbackPath = path.resolve(__dirname, '../serviceAccountKey.json');

let serviceAccount;
if (fs.existsSync(serviceAccountPath)) {
  serviceAccount = require(serviceAccountPath);
} else if (fs.existsSync(fallbackPath)) {
  serviceAccount = require(fallbackPath);
} else {
  console.error('ERROR: Could not locate serviceAccountKey.json in functions/ or root folder.');
  process.exit(1);
}

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function seedUnit01() {
  console.log('=== PCSA ACADEMY: SEEDING STBB CLASS 11 UNIT 01 BUNDLE ===');

  try {
    const notesPath = path.resolve(__dirname, '../assets/curriculum/stbb_11/unit_01_notes.md');
    const exercisesPath = path.resolve(__dirname, '../assets/curriculum/stbb_11/unit_01_exercises.md');
    const quizPath = path.resolve(__dirname, '../assets/curriculum/stbb_11/unit_01_quiz.json');
    const labPath = path.resolve(__dirname, '../assets/curriculum/stbb_11/unit_01_lab.md');

    const notesMarkdown = fs.readFileSync(notesPath, 'utf8');
    const exercisesMarkdown = fs.readFileSync(exercisesPath, 'utf8');
    const quizData = JSON.parse(fs.readFileSync(quizPath, 'utf8'));
    const labMarkdown = fs.readFileSync(labPath, 'utf8');

    const docId = 'stbb_cs_class11_unit01';
    const payload = {
      id: docId,
      board: 'STBB',
      curriculumStream: 'stbb',
      class: 11,
      targetClass: 'class_11',
      unitNumber: 1,
      unitTitle: 'Computer Systems',
      description: 'Exhaustive Unit 1 coverage: Von Neumann Architecture, Bus Systems, Memory Hierarchy, Software Classification, and Interactive Lab Exercises.',
      isLocked: false, // Free preview MVP
      isPublished: true,
      notesMarkdown: notesMarkdown,
      exercisesMarkdown: exercisesMarkdown,
      labMarkdown: labMarkdown,
      quizData: quizData,
      notesDriveUrl: 'https://drive.google.com/open?id=1vpIz70_LusjYmSNMObzBQXGeEcK0zhO7',
      solvedExercisesDriveUrl: 'https://drive.google.com/open?id=1vpIz70_LusjYmSNMObzBQXGeEcK0zhO7',
      labJournalDriveUrl: 'https://drive.google.com/open?id=1vpIz70_LusjYmSNMObzBQXGeEcK0zhO7',
      pastPapersDriveUrl: 'https://drive.google.com/open?id=1vpIz70_LusjYmSNMObzBQXGeEcK0zhO7',
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    await db.collection('curriculum_resources').doc(docId).set(payload, { merge: true });

    console.log(`✅ SUCCESS: Unit 1 bundle seeded successfully under document ID: '${docId}'`);
    console.log(`📊 Statistics: Notes (${notesMarkdown.length} chars), Exercises (${exercisesMarkdown.length} chars), Lab (${labMarkdown.length} chars), Quiz (${quizData.length} MCQs).`);
    process.exit(0);
  } catch (error) {
    console.error('❌ SEEDING ERROR:', error.message);
    process.exit(1);
  }
}

seedUnit01();
