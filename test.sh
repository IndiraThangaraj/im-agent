#!/bin/bash

# n8n test webhook URL
WEBHOOK_URL="http://0.0.0.0:5678/webhook/baa9beec-862d-4c55-86c2-003f2830a2ab"

echo "--- Test Case 1: Incomplete Email (Rejection Path) ---"
# This email is missing most of the required fields.
# Expected: A rejection message "Please follow the SFU Email template..."
curl -X POST "$WEBHOOK_URL" \
-H "Content-Type: application/json" \
-d '{
  "email_content": "Hi team, my card is not working. Please help. My username is testuser."
}'
echo -e "\n\n"
sleep 2

echo "--- Test Case 2: Complete Email, No SOP Found (Approval Path -> Fallback) ---"
# This email is complete but describes an issue (phishing) that is not in our sample SOPs.
# Expected: An HTML RCA report with "No resolution found in SOPs." / Recommended Actions by the Agent
curl -X POST "$WEBHOOK_URL" \
-H "Content-Type: application/json" \
-d '{
  "email_content": "Username: user123\nCard Number: 4567...\nAccess Number: 9876\nGCIF Number: 111222\nIC Number: 900101-01-5000\nDate and Timestamp of Issue Happened: 2025-11-04 14:00\nProblem Statement: My account is locked out after a phishing attempt.\nNumber of impacted customer: 1\nSteps to reproduce the issue: 1. Try to log in. 2. Get error."
}'
echo -e "\n\n"
sleep 2

echo "--- Test Case 3: Complete Email, SOP Found (Happy Path) ---"
# This email is complete and describes an issue where the user is unable to view favourite list in JOMPAY, which IS in our SOPs.
# Expected: An HTML RCA report with resolution steps from SOP Vector Store.
curl -X POST "$WEBHOOK_URL" \
-H "Content-Type: application/json" \
-d '{
  "email_content": "Username: user456\nCard Number: 1234...\nAccess Number: 5555\nGCIF Number: 333444\nIC Number: 880202-02-6000\nDate and Timestamp of Issue Happened: 2025-11-04 14:30\nProblem Statement: i cannot view jompay favourite list.\nNumber of impacted customer: 1\nSteps to reproduce the issue: 1. Go to reset page. 2. Enter IC. 3. Get error."
}'
echo -e "\n\n"

echo "--- Test Script Finished ---"