#!/bin/bash

# Get DTP 
POD="$(kubectl get pods | grep dtp | grep Running | awk '{print $1}')"

# copy data to local machine
echo "copying data..."
kubectl exec $POD --container dtp-base -- bash -c "for f in \$(find $1 -type l); do cp --remove-destination \$(readlink \$f) \$f; done"
kubectl cp "$POD:$1" "$(basename $1)" -c dtp-base
echo "done!"
