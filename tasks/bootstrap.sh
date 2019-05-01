#!/bin/bash

set -euxo pipefail

pushd gcp-bootstrap/tf/ci
  terraform init

  terraform apply \
    -auto-approve \
    -input=false \
    -state=../../../tfstate/terraform.tfstate \
    -state-out=../../../tfstate-out/terraform.tfstate
popd

