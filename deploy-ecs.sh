#!/bin/bash

set -e

# possible -b (base / app name) -i (image version), -e (deploy env) and -s (service id)
while getopts b:i:e:s: option
do
case "${option}"
in
t) TASK_FAMILY=${OPTARG};;
s) SERVICE_NAME=${OPTARG};;
c) CLUSTER_NAME=${OPTARG};;
i) IMAGE_VERSION=${OPTARG};;
esac
done

echo "TASK_FAMILY: " $TASK_FAMILY
echo "SERVICE_NAME: " $SERVICE_NAME
echo "CLUSTER_NAME: " $CLUSTER_NAME
echo "SERVICE_ID: " $SERVICE_ID
echo "IMAGE_VERSION: " $IMAGE_VERSION

IMGAGE_PACEHOLDER="<IMGAGE_VERSION>"

CONTAINER_DEFINITION_FILE=$(cat ${Container-Definition.json)
CONTAINER_DEFINITION="${CONTAINER_DEFINITION_FILE//$IMGAGE_PACEHOLDER/$IMG_VERSION}"


export TASK_VERSION=$(aws ecs register-task-definition --family ${TASK_FAMILY} --container-definitions "$CONTAINER_DEFINITION" | jq --raw-output '.taskDefinition.revision')
echo "Registered ECS Task Definition: " $TASK_VERSION


if [ -n "$TASK_VERSION" ]; then
    echo "Update ECS Cluster: " $CLUSTER_NAME
    echo "Service: " $SERVICE_NAME
    echo "Task Definition: " $TASK_FAMILY:$TASK_VERSION
    
    DEPLOYED_SERVICE=$(aws ecs update-service --cluster $CLUSTER_NAME --service $SERVICE_NAME --task-definition $TASK_FAMILY:$TASK_VERSION | jq --raw-output '.service.serviceName')
    echo "Deployment of $DEPLOYED_SERVICE complete"

else
    echo "exit: No task definition"
    exit;
fi
