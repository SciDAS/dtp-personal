#!/bin/sh

export IRODS_ENV=$(cat $1 | base64 | tr -d '\n')
export IRODS_PASS=$2

cat > templates/irods-secret.yaml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: irods
type: Opaque
stringData:
    IRODS_PASSWORD: "${IRODS_PASS}"
data:
  irods_environment.json: ${IRODS_ENV}
EOF

cat templates/irods-secret.yaml
