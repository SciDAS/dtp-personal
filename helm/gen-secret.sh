#!/bin/sh

export IRODS_ENV=$(cat $1 | base64 | tr -d '\n')

cat > templates/secret.yaml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: irods
type: Opaque
data:
  config: ${IRODS_ENV}
EOF

cat templates/secret.yaml
