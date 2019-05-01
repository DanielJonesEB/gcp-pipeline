#!/bin/bash

set -euxo pipefail

pushd gcp-bootstrap/tf/ci
  terraform init

  terraform destroy \
    -auto-approve \
    -input=false
popd

