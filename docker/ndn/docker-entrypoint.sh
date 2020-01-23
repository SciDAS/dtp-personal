#!/bin/bash
set -e

echo 'export IRODS_ENVIRONMENT_FILE=/etc/.irods/irods_environment.json' >> ~/.bashrc && source ~/.bashrc

if [[ ${IRODS_PASSWORD} && ${IRODS_ENVIRONMENT_FILE} ]]; then
    iinit ${IRODS_PASSWORD}
fi

"$@"

exit $?
