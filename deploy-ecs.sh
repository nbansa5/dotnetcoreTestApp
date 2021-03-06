#!/bin/bash
echo "Inside Script"
set -e

# possible -b (base / app name) -i (image version), -e (deploy env) and -s (service id)
while getopts t:s:c:i: option
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
echo "IMAGE_VERSION: " $IMAGE_VERSION

IMGAGE_PACEHOLDER="<IMGAGE_VERSION>"

CONTAINER_DEFINITION_FILE=$(cat Container-Definition.json)
echo "CONTAINER_DEFINITION_FILE: " $CONTAINER_DEFINITION_FILE
CONTAINER_DEFINITION_FILE=${CONTAINER_DEFINITION_FILE//$IMGAGE_PACEHOLDER/$IMAGE_VERSION}
echo "Modified CONTAINER_DEFINITION_FILE: " $CONTAINER_DEFINITION_FILE
echo $(rm Container-Definition.json)
echo $CONTAINER_DEFINITION_FILE | tee Container-Definition.json

#export TASK_VERSION=$(aws ecs register-task-definition --family ${TASK_FAMILY} --container-definitions $CONTAINER_DEFINITION_FILE )
TASK_VERSION=$(aws ecs register-task-definition --cli-input-json file://./Container-Definition.json)
echo "Registered ECS Task Definition: " $TASK_VERSION
SUBSTRING=$(echo $TASK_VERSION| cut -d',' -f 20)
SUBSTRING=$(echo $SUBSTRING| cut -d':' -f 2)
SUBSTRING=$(echo $SUBSTRING| cut -d'}' -f 1)
echo $SUBSTRING

#echo ${SUBSTRING:0,2}

#IFS=',' read -ra NAMES <<< "$TASK_VERSION"
#for i in "${NAMES[@]}"; do
#    echo $i
#done 

if [ -n "$TASK_VERSION" ]; then
    #echo "Update ECS Cluster: " $CLUSTER_NAME
    #echo "Service: " $SERVICE_NAME
    #echo "Task Definition: " $TASK_FAMILY:$TASK_VERSION
    DEPLOYED_SERVICE=$(aws ecs update-service --cluster $CLUSTER_NAME --service $SERVICE_NAME --task-definition $TASK_FAMILY:$SUBSTRING --force-new-deployment)
    echo "Deployment of $DEPLOYED_SERVICE complete"

else
    echo "exit: No task definition"
    exit;
fi
