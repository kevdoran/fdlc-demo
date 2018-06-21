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

# Export latest version of flow from registry-1
./nifi-toolkit-1.7.0/bin/cli.sh registry export-flow-version -u http://localhost:18080 -f 3631c557-b087-4478-b7e2-3bff32fc7c65 -o exported-flow.json

# Create flow in registry-2
./nifi-toolkit-1.7.0/bin/cli.sh registry create-flow -u http://localhost:18081 -b 60eb8886-3ec5-46c4-bce8-1e388b55d4fa -fn "Process Event Logs"

# Discover flow id of the flow we just created
registry2_flow_id=$(./nifi-toolkit-1.7.0/bin/cli.sh registry list-flows -u http://localhost:18081 -b 60eb8886-3ec5-46c4-bce8-1e388b55d4fa --outputType json | jq '.[0].identifier')
echo "$registry2_flow_id"

# Import previously exported flow version into registry2.flow
./nifi-toolkit-1.7.0/bin/cli.sh registry import-flow-version -u http://localhost:18081 -f $registry2_flow_id -i exported-flow.json

