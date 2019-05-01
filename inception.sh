#!/bin/bash

set -euxo pipefail

ORG_ID=478443594646
PROJECT_ID=inception-239309

gcloud iam service-accounts keys create inception-creds.json \
  --iam-account terraform@${PROJECT_ID}.iam.gserviceaccount.com \
  --project ${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/viewer
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com \
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
  --member serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/resourcemanager.projectCreator
gcloud organizations add-iam-policy-binding ${ORG_ID} \
  --member serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/billing.user
gcloud organizations add-iam-policy-binding ${ORG_ID} \
  --member serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/resourcemanager.folderViewer
