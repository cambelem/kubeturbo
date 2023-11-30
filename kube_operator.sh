#!/bin/env bash

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
ERR_LOG=$(mktemp --suffix _kube.errlog)
WAIT_FOR_DEPLOYMENT=20
OPERATOR_IMAGE_VERSION="8.9.5-SNAPSHOT"
OPERATOR_IMAGE="icr.io\/cpopen\/kubeturbo-operator:${OPERATOR_IMAGE_VERSION}"
OPERATOR_NS=turbo



function install_operator {
	NS=$1
	kubectl create ns ${NS}
	kubectl delete -f ${SCRIPT_DIR}/deploy/crds/*crd.yaml
	kubectl apply -f ${SCRIPT_DIR}/deploy/crds/*crd.yaml
	kubectl apply -f ${SCRIPT_DIR}/deploy/kubeturbo-operator-cluster-role.yaml
	kubectl apply -f ${SCRIPT_DIR}/deploy/service_account.yaml -n ${NS}
	kubectl apply -f ${SCRIPT_DIR}/deploy/role_binding.yaml

	# dynamically apply the image version
	sed "s/image:.*/image: ${OPERATOR_IMAGE}/g" ${SCRIPT_DIR}/deploy/operator.yaml > ${SCRIPT_DIR}/deploy/updated_operator.yaml
	kubectl apply -f ${SCRIPT_DIR}/deploy/updated_operator.yaml -n ${NS}
}


function main {
	
	echo "Installing kubeturbo operator..."
	install_operator ${OPERATOR_NS}

	kubectl get all -n ${OPERATOR_NS}
}

main
