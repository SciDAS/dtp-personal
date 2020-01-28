#!/bin/bash

# Arguments
#while getopts ":i" opt; do
#  case $opt in
#    i )
#      echo "Interactive mode enabled." >&2
#      INTERACTIVE=true
#      ;;
#    \? )
#      echo "Invalid option: -$OPTARG" >&2
#      exit 1
#      ;;
#  esac
#done

# Deploy DTP
helm install dtp helm
POD="$(kubectl get pods | grep dtp | grep ContainerCreating | awk '{print $1}')"
echo "Data Transfer Pod: ${POD}"

POD_STATUS="$(kubectl get pod ${POD} | awk 'FNR == 2 {print $3}')"
echo "${POD_STATUS}"
while [ "${POD_STATUS}" != "Running" ]; do 
  sleep 1 
  POD_STATUS="$(kubectl get pod ${POD} | awk 'FNR == 2 {print $3}')"
  echo "${POD_STATUS}"
  done
echo "DTP started."

# Run entrypoint script
# sleep 1
# kubectl exec ${POD} -- /bin/bash /docker-entrypoint.sh

# Start interactive session
# if [ $INTERACTIVE ] ; then
#    kubectl exec -it ${POD} -- /bin/bash
# fi



#helm uninstall dtp

