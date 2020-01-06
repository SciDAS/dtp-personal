#!/bin/bash
set -e

export IRODS_ENVIRONMENT_FILE=/irods_environment.json

if [[ ${IRODS_PASSWORD} ]]; then
    iinit ${IRODS_PASSWORD}
fi

"$@"

exit $?
