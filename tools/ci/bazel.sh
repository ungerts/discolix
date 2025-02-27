#!/usr/bin/env sh
# Copyright 2019 Erik Maciejewski
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DEFAULT_BUILD_FQIN="discolix/build:latest"

if [ -z "$PROJECT_BUILD_FQIN" ]; then
    PROJECT_BUILD_FQIN=$DEFAULT_BUILD_FQIN
fi

docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $PWD:/build \
    -w /build \
    $PROJECT_BUILD_FQIN bazel --bazelrc=tools/ci/.bazelrc $@
