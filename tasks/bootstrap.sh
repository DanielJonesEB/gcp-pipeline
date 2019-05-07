#!/bin/bash

set -euxo pipefail

: "${GCP_CREDS_JSON:?GCP_CREDS_JSON env var must provide contents of credentials file}"
: "${PROJECT_ID:?PROJECT_ID env var must be provided}"

echo "${GCP_CREDS_JSON}" > creds.json
export GOOGLE_APPLICATION_CREDENTIALS=$PWD/creds.json

matching_project="$(gcloud projects list --format json | jq '.[] | select(.projectId=="${PROJECT_ID)") | .projectId')"

if [[ $matching_project == *"${PROJECT_ID}"* ]]; then
  buckets="$(gsutil ls -p "${PROJECT_ID}")"

  if [[ $buckets == *"${PROJECT_ID}"* ]]; then
    echo "Existing bucket found for project ${PROJECT_ID}"

    if gsutil stat -q "gs://${PROJECT_ID}/terraform/terraform.tfstate"; then
      gsutil cp "gs://${PROJECT_ID}/terraform/terraform.tfstate" terraform.tfstate
    else
      echo "Error - project bucket exists, but terraform/terraform.tfstate does not"
      exit 1
    fi
  else
    echo "No existing bucket found for project ${PROJECT_ID}, assuming first run"
  fi
else
  echo "No existing project ${PROJECT_ID}, assuming first run"
fi


pushd gcp-bootstrap/tf/ci
  terraform init

  TF_VAR_gcp_creds="${GCP_CREDS_JSON}" \
    TF_VAR_project_id="${PROJECT_ID}" \
    terraform apply \
    -auto-approve \
    -input=false \
    -state=../../../terraform.tfstate \
    -state-out=../../../tfstate-out/terraform.tfstate
popd

