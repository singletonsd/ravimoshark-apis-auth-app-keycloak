#!/usr/bin/env bash

# Web Page of BASH best practices https://kvz.io/blog/2013/11/21/bash-best-practices/
#Exit when a command fails.
set -o errexit
#Exit when script tries to use undeclared variables.
set -o nounset
#The exit status of the last command that threw a non-zero exit code is returned.
set -o pipefail

#Trace what gets executed. Useful for debugging.
#set -o xtrace

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename "${__file}" .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)"

echo "Script name: ${__base}"
echo "Executing at ${__root}"

if [ -f .keycloak.env ]
then
    # shellcheck disable=SC2046
    export $(< .env sed 's/#.*//g' | xargs)
    # export $(grep -v '^#' .env.swagger | xargs)
fi

if [ -z "${KEYCLOAK_SERVER_REALM+x}" ]; then
    echo: "ERROR: KEYCLOAK_SERVER_REALM variable not provided!"
    exit 1
fi

echo "Creating groups sav"
kcadm.sh create groups \
  --target-realm ${KEYCLOAK_SERVER_REALM} \
  --set name=sav -o

echo "Creating groups commercial"
kcadm.sh create groups \
  --target-realm ${KEYCLOAK_SERVER_REALM} \
  --set name=commercial -o

echo "Creating groups technical"
kcadm.sh create groups \
  --target-realm ${KEYCLOAK_SERVER_REALM} \
  --set name=technical -o

echo "Creating groups management"
kcadm.sh create groups \
  --target-realm ${KEYCLOAK_SERVER_REALM} \
  --set name=management -o