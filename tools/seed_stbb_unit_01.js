/**
 * PCSA Academy • Official STBB Class 11 Unit 1 Firestore Purge & Seed Tool
 * Executable script to purge legacy CPU architecture content and seed the new official
 * STBB Unit 1 (Digital Logic Design, K-Maps, Logisim Evolution, SDLC, Waterfall & Agile) bundle into Cloud Firestore.
 *
 * Run: node tools/seed_stbb_unit_01.js
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
  projectId: serviceAccount.project_id || 'academic-portal-pk',
});

const db = admin.firestore();

async function purgeAndSeedSTBBUnit01() {
  console.log('=== PCSA ACADEMY: PURGING LEGACY CONTENT & SEEDING OFFICIAL STBB CLASS 11 UNIT 01 ===');

  try {
    const docId = 'stbb_cs_class11_unit01';
    const resourceRef = db.collection('curriculum_resources').doc(docId);

    // 1. Purge previous record if exists
    console.log(`-> Purging legacy CPU architecture data at '/curriculum_resources/${docId}'...`);
    await resourceRef.delete();

    // 2. Read new official STBB assets
    const notesPath = path.resolve(__dirname, '../assets/curriculum/stbb_11/unit_01_notes.md');
    const exercisesPath = path.resolve(__dirname, '../assets/curriculum/stbb_11/unit_01_exercises.md');
    const quizPath = path.resolve(__dirname, '../assets/curriculum/stbb_11/unit_01_quiz.json');
    const labPath = path.resolve(__dirname, '../assets/curriculum/stbb_11/unit_01_lab.md');

    const notesMarkdown = fs.readFileSync(notesPath, 'utf8');
    const exercisesMarkdown = fs.readFileSync(exercisesPath, 'utf8');
    const quizData = JSON.parse(fs.readFileSync(quizPath, 'utf8'));
    const labMarkdown = fs.readFileSync(labPath, 'utf8');

    // 3. Construct new official STBB payload
    const payload = {
      id: docId,
      board: 'STBB',
      curriculumStream: 'stbb',
      class: 11,
      targetClass: 'class_11',
      unitNumber: 1,
      unitTitle: 'Computer Systems & Logic Design',
      description: 'Official 2026 STBB Curriculum: Discrete vs Continuous Quantities, Boolean Algebra & 7 Logic Gates, Canonical Forms & K-Maps, Logisim Evolution v3.9+, 6 SDLC Phases, and Waterfall & Agile Case Studies.',
      isLocked: false, // Free preview MVP
      isPublished: true,
      topics: [
        'Discrete vs Continuous',
        'Digital Signals',
        'Boolean Algebra',
        'Logic Gates',
        'K-Maps',
        'Logisim Evolution',
        'SDLC Phases',
        'Waterfall & Agile Models',
      ],
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

    // 4. Overwrite in Firestore
    await resourceRef.set(payload);

    console.log(`✅ SUCCESS: Official STBB Unit 1 bundle seeded successfully into '/curriculum_resources/${docId}'!`);
    console.log(`📊 Asset Stats: Notes (${notesMarkdown.length} chars), Solved Exercises (${exercisesMarkdown.length} chars), Lab Manual (${labMarkdown.length} chars), Quiz (${quizData.length} MCQs).`);
    process.exit(0);
  } catch (error) {
    console.error('❌ SEEDING ERROR:', error.message);
    process.exit(1);
  }
}

purgeAndSeedSTBBUnit01();
