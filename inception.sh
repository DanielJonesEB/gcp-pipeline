#!/bin/bash

set -euxo pipefail

: "${BILLING_ACCOUNT_ID:?BILLING_ACCOUNT_ID env var must specify the ID of the linked billing account}"
: "${FOLDER_ID:?FOLDER_ID env var must specify which folder to place the inception project in}"
: "${ORG_ID:?ORG_ID env var must specify the Google Cloud organisation}"

gcloud projects create ${PROJECT_ID} --folder ${FOLDER_ID}
gcloud beta billing projects link ${PROJECT_ID} --billing-account ${BILLING_ACCOUNT_ID}

gcloud iam service-accounts keys create inception-creds.json \
  --iam-account inception@${PROJECT_ID}.iam.gserviceaccount.com \
  --project ${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:inception@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/viewer
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:inception@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/storage.admin

gcloud services enable cloudresourcemanager.googleapis.com \
  --project ${PROJECT_ID}
gcloud services enable cloudbilling.googleapis.com \
  --project ${PROJECT_ID}
gcloud services enable iam.googleapis.com \
  --project ${PROJECT_ID}
gcloud services enable compute.googleapis.com \
  --project ${PROJECT_ID}

gcloud organizations add-iam-policy-binding ${ORG_ID} \
  --member serviceAccount:inception@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/resourcemanager.projectCreator
gcloud organizations add-iam-policy-binding ${ORG_ID} \
  --member serviceAccount:inception@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/billing.user
gcloud organizations add-iam-policy-binding ${ORG_ID} \
  --member serviceAccount:inception@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/billing.viewer
gcloud organizations add-iam-policy-binding ${ORG_ID} \
  --member serviceAccount:inception@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/resourcemanager.folderViewer
