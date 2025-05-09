# controller-argocd-core

This repository provides a controller that enables declarative installation of
ArgoCD Core within an Upbound control plane.

## Overview

The ArgoCD Core Controller facilitates continuous delivery and declarative configuration management of Kubernetes applications using GitOps principles. It deploys the following ArgoCD components in non-HA mode: `argocd-server`, `application-controller`, `applicationset-controller`, `repo-server`, and `redis`.

## Usage

### Prerequisites

- Upbound account with appropriate permissions
- kubectl CLI installed and configured
- Upbound CLI (`up`) installed

### Installation

1. Create a control plane in Upbound

```bash
UPBOUND_ORG="your_upbound_org"
# Other spaces are available, check with `up ctx`
# you need a space with enabled controller feature
UPBOUND_SPACE="space-the-final-frontier"
UPBOUND_GROUP="your_group_name"
UPBOUND_CTP="your_controlplane_name"

# Create Profile
up profile create $UPBOUND_ORG --organization $UPBOUND_ORG
up profile use $UPBOUND_ORG

# Login and switch context
up login -a $UPBOUND_ORG --profile $UPBOUND_ORG
up ctx "${UPBOUND_ORG}/${UPBOUND_SPACE}"

# Create group
up group create "${UPBOUND_GROUP}"

# Switch context to group
up ctx "${UPBOUND_ORG}/${UPBOUND_SPACE}/${UPBOUND_GROUP}"

# Create control plane
up ctp create "${UPBOUND_CTP}" --crossplane-channel="Rapid"

# Check status of control plane (should show Healthy: True)
up ctp list

# Switch context to control plane (might take a minute to become ready)
up ctx "${UPBOUND_ORG}/${UPBOUND_SPACE}/${UPBOUND_GROUP}/${UPBOUND_CTP}"
```

2. Install the controller:

   *This installs the controller package into your control plane, which includes the ArgoCD Core CRD and the manifests required to run ArgoCD Core.*

```bash
UP_CHART_VERSION=""

cat <<EOF | kubectl apply -f -
  apiVersion: pkg.upbound.io/v1alpha1
  kind: Controller
  metadata:
    name: controller-argocd-core
  spec:
    package: xpkg.upbound.io/upbound/controller-argocd-core:"${UP_CHART_VERSION}"
EOF
```

## Development

### Testing

The repository includes test configurations:

- Basic e2e test: `tests/e2etest-argocd-core/`

To run tests:

```bash
UP_CHART_VERSION="" up test run tests/* --e2e
```
