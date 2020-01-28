#!/bin/bash

# Get DTP 
POD="$(kubectl get pods | grep dtp | grep Running | awk '{print $1}')"

# copy data to pod
echo "copying data..."
kubectl exec $POD --container dtp-base -- bash -c "mkdir -p $2"
kubectl cp "$1" "$POD:$2/$(basename $1)" -c dtp-base
echo "done!"
