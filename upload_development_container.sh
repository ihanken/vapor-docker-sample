#!/bin/bash
#Constants

DOCKER_LOGIN=`aws ecr get-login --region us-west-2`
REGION=us-west-2
REPOSITORY_NAME=league-bot
CLUSTER=discord-bots
FAMILY=league-bot-development
NAME=league-bot-development
SERVICE_NAME=${NAME}-service
SERVICES=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .failures[]`

# Login to ECR.
${DOCKER_LOGIN}

# Tag the new container
docker tag league-bot 928610031571.dkr.ecr.us-west-2.amazonaws.com/league-bot:development-v_${BUILD_NUMBER}

# Push the new container.
docker push 928610031571.dkr.ecr.us-west-2.amazonaws.com/league-bot:development-v_${BUILD_NUMBER}

#Store the repositoryUri as a variable
REPOSITORY_URI=`aws ecr describe-repositories --repository-names ${REPOSITORY_NAME} --region ${REGION} | jq .repositories[].repositoryUri | tr -d '"'`

#Replace the build number and respository URI placeholders with the constants above
sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" -e "s;%REPOSITORY_URI%;${REPOSITORY_URI};g" -e "s;%LEAGUE_BOT_DEVELOPMENT_TOKEN%;${LEAGUE_BOT_DEVELOPMENT_TOKEN};g" -e "s;%RIOT_API_KEY%;${RIOT_API_KEY};g" DevelopmentTaskDefinition.json > ${NAME}-v_${BUILD_NUMBER}.json
echo ${LEAGUE_BOT_DEVELOPMENT_TOKEN}
cat ${NAME}-v_${BUILD_NUMBER}.json
#Register the task definition in the repository
aws ecs register-task-definition --family ${FAMILY} --cli-input-json file://${NAME}-v_${BUILD_NUMBER}.json --region ${REGION}
SERVICES=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .failures[]`
#Get latest revision
REVISION=`aws ecs describe-task-definition --task-definition ${NAME} --region ${REGION} | jq .taskDefinition.revision`

#Create or update service
if [ "$SERVICES" == "" ]; then
  echo "entered existing service"
  DESIRED_COUNT=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .services[].desiredCount`
  if [ ${DESIRED_COUNT} = "0" ]; then
    DESIRED_COUNT="1"
  fi
  aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --task-definition ${FAMILY}:${REVISION} --desired-count ${DESIRED_COUNT}
else
  echo "entered new service"
  aws ecs create-service --service-name ${SERVICE_NAME} --desired-count 1 --task-definition ${FAMILY} --cluster ${CLUSTER} --region ${REGION}
fi
