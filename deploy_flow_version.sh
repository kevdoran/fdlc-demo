#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Deploys Process Event Logs to target environment
#
# Default values for the following can be overwritten with ENV vars:
#    PG_ID       the target process group to update
#    FLOW_NAME   the name of the flow being deployed

# Exit if any command fails
set -e

# Read arguments 
version="$1"
target_env="$2"

# Set Global Defaults
[ -z "$FLOW_NAME" ] && FLOW_NAME="Process Event Logs"

# Set environment specific defaults
# In the future, these could be dynamically discovered
case "$target_env" in
staging)
  ENV_PROPS="env/nifi-staging";
  [ -z "$PG_ID" ] && PG_ID="230322f6-0164-1000-90d4-503065a7f3ef";;
prod)
  ENV_PROPS="env/nifi-prod";
  [ -z "$PG_ID" ] && PG_ID="1b221c70-0164-1000-5130-4eefc5bd4b4a";;
*)
  echo "Usage: $(basename "$0") <version> <environment> "; exit 1;;
esac

echo 
echo "Deploying version ${version} of '${FLOW_NAME}' to ${target_env}"
echo "======================================================="
echo

echo -n "Checking current version... "
current_version=$(./nifi-toolkit-1.7.0/bin/cli.sh nifi pg-get-version -pgid ${PG_ID} -ot json -p ${ENV_PROPS} | jq '.versionControlInformation.version')
echo -e "[\033[0;32mOK\033[0m]"
echo
echo "Flow '${FLOW_NAME}' in ${target_env} is currently at version: ${current_version}"
echo

echo -n "Deploying flow............. "
./nifi-toolkit-1.7.0/bin/cli.sh nifi pg-change-version -pgid "$PG_ID" -fv $version -p "$ENV_PROPS" > /dev/null
echo -e "[\033[0;32mOK\033[0m]"

echo -n "Enabling services.......... "
./nifi-toolkit-1.7.0/bin/cli.sh nifi pg-enable-services -pgid "$PG_ID" -p "$ENV_PROPS" > /dev/null
echo -e "[\033[0;32mOK\033[0m]"

echo -n "Starting process group..... "
./nifi-toolkit-1.7.0/bin/cli.sh nifi pg-start -pgid "$PG_ID" -p "$ENV_PROPS" > /dev/null
echo -e "[\033[0;32mOK\033[0m]"

echo
echo "Flow deployment successful, ${target_env} is now at version: ${version}"
echo

exit 0
