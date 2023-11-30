# Microshift Custom KubeTurbo

## Install Guide

1. Open `kube_operator.sh` and update the following variables:
    - `OPERATOR_IMAGE_VERSION`: Your Turbonomic Version
    - [Optional] `OPERATOR_NS`: Choose a different namespace name

2. Make `kube_operator.sh` executable by running `chmod +x kube_operator.sh`

3. Run the script: `./kube_operator.sh`

## Troubleshooting

1. After the CRD has been created, if the deployment is stuck in 0/1 via `oc get all -n <chosen_namespace>`, remove the CRD and run the following command: `oc label ns <chosen_namespace> pod-security.kubernetes.io/enforce=privileged`
2. Reapply the CRD