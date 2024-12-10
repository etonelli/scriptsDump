#Lancio del workflow associato all'SRG sulla piattaforma Dynatrace
curl -s -H 'Authorization: Bearer <USA IL TUO TOKEN>' -X POST <USA URL WORKFLOW ONDEMAND> > .last_EXEC_ID

#Estrazione dell'ultimo Workflow EXEC_ID per interrogare successivamente le execution API
EXEC_ID="$(cat .last_EXEC_ID | jq -r '.id')"
echo "Workflow execution id:" "$EXEC_ID"

#Ciclo di attesa e verifica che il workflow sia terminato
while [ "$EXEC_STATUS" != "SUCCESS" ]
do
	sleep 5
	EXEC_STATUS="$(curl -s -X 'GET' '<IL TUO URL DYNATRACE>/platform/automation/v1/executions/'$EXEC_ID'/tasks?adminAccess=false' -H 'Authorization: Bearer <TUO TOKEN SOLO LETTURA>' | jq -r '.run_vulnerableapp_validation.state')"
done
echo "Esecuzione del workflow terminata:" "$EXEC_STATUS"

#Estrazione e presentazione dei risultati
EXEC_QG_RESULTS="$(curl -s -X 'GET' '<IL TUO URL DYNATRACE>/platform/automation/v1/executions/'$EXEC_ID'/tasks?adminAccess=false' -H 'Authorization: Bearer <TUO TOKEN SOLO LETTURA>' | jq -r '.run_vulnerableapp_validation.result.validation_details[].status')"

echo "Il Security Gate ha avuto esito:" "$EXEC_QG_RESULTS"

EXEC_QG_VULNS="$(curl -s -X 'GET' '<IL TUO URL DYNATRACE>/platform/automation/v1/executions/'$EXEC_ID'/tasks?adminAccess=false' -H 'Authorization: Bearer <TUO TOKEN SOLO LETTURA>' | jq -r '.run_vulnerableapp_validation.result.validation_details[].value')"

echo "Numero di vulnerabilità trovate nel runtime e associate ai processi:" "$EXEC_QG_VULNS"
