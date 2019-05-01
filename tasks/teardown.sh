#!/bin/bash

set -euxo pipefail

pushd gcp-bootstrap/tf/ci
  terraform init

  terraform destroy \
    -auto-approve \
    -input=false \
    -state=../../../tfstate/terraform.tfstate
popd

