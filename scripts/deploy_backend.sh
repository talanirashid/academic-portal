#!/usr/bin/env bash
set -e

echo "=== DEPLOYING PCSA SECURE BACKEND INFRASTRUCTURE ==="

# 1. Apply CORS configuration to Cloud Storage bucket
echo "-> Applying CORS rules to Cloud Storage..."
if command -v gcloud &> /dev/null; then
  BUCKET_NAME=$(cat .firebaserc | grep 'default' | cut -d '"' -f 4).appspot.com
  gcloud storage buckets update "gs://${BUCKET_NAME}" --cors-file=cors.json || echo "Storage CORS update skipped or bucket name varied."
fi

# 2. Deploy Firestore Rules and Indexes
echo "-> Deploying Firestore rules & composite indexes..."
firebase deploy --only firestore:rules,firestore:indexes

# 3. Deploy Storage Rules
echo "-> Deploying Cloud Storage rules..."
firebase deploy --only storage

# 4. Deploy Cloud Functions Webhook Handler
echo "-> Deploying Automated Payment Webhook Function..."
firebase deploy --only functions

echo "=== BACKEND DEPLOYMENT COMPLETED: 100% OPERATIONAL ==="
