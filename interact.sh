#!/bin/bash


# Get DTP and set containers to an array
POD="$(kubectl get pods | grep dtp | grep Running | awk '{print $1}')"
ARRAY=($(kubectl get pods ${POD} -o jsonpath='{.spec.containers[*].name}'))

# Iterate through interactive mode
while [[ $CHOICE != '0' ]]; do
echo "--------------------"
echo "- INTERACTIVE MODE -"
echo "--------------------"
echo "Data Transfer Pod: ${POD}"
COUNTER=1
  # Display options
  for i in $(kubectl get pods ${POD} -o jsonpath='{.spec.containers[*].name}'); do
    echo "Press $COUNTER to enter $i"
    COUNTER=$((COUNTER+1))
  done
  echo "Press 0 to exit Interactive Mode"
  echo "------------------"
  # Get choice and enter chosen container
  read -p "Selection: " CHOICE
  for j in $(seq 1 $COUNTER); do
    if [ "${CHOICE}" -eq $j ]; then 
      POS=$(($CHOICE-1))
      echo "Entering ${ARRAY[${POS}]}...."
      sleep 1
      kubectl exec -it ${POD} --container ${ARRAY[${POS}]} -- /bin/bash
    fi
  done
done
