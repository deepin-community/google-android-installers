#!/bin/bash

set -e

SCRIPT_PATH=$(dirname $0)

cd $SCRIPT_PATH
source _components_to_package.sh

if [ -n "$1" ]; then
    echo ${!1}
fi
