#!/bin/bash

set -euxo pipefail

pushd gcp-bootstrap/tf/ci
  terraform init

  terraform apply \
    -auto-approve \
    -input=false \
    -state-out=../tfstate/terraform.tfstate
popd

