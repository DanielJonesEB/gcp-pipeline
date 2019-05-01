#!/bin/bash

set -euxo pipefail

terraform apply \
  -auto-approve \
  -input=false \
  -state-out=../tfstate/terraform.tfstate
