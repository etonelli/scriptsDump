#!/bin/bash

command=$1
app_name=$(echo "$2" | sed 's/ /%20/g')
trigger=$3

tenant=$4
api_token=$5

case $command in
  getOpenVulns)
    totalOpenVulns=$(curl -s -X 'GET' "$tenant/api/v2/securityProblems?securityProblemSelector=affectedPgNameContains%28%22$app_name%22%29%2Cstatus%28%22OPEN%22%29" -H 'accept: application/json; charset=utf-8' -H "Authorization: Api-Token $api_token" | jq -r '.totalCount')
    if [ $totalOpenVulns -gt $trigger ]; then
      echo Artifact NOT compliant to the required Security Gate.
      echo Total Vulnerabilities found for $2: $totalOpenVulns
      exit 2
    else
      echo Artifact OK to the required Security Gate.
      echo Total Vulnerabilities found for $2: $totalOpenVulns
      exit 1
    fi
    ;;
  getFullByPgName)
    exit 0
    ;;
esac

exit 0