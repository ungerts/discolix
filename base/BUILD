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

package(default_visibility = ["//visibility:public"])

load("@io_bazel_rules_docker//container:container.bzl", "container_image")
load("//private:debian_buster.bzl", "debian_buster")
load("//private:platforms.bzl", "PLATFORMS")
load("//private/noarch:files.bzl", "NONROOT")

# static

[container_image(
    name = "static-" + platform,
    layers = ["//private/layer:root-" + platform],
    stamp = True,
    tars = ["//private/noarch:base-files"],
) for (platform, os, arch) in PLATFORMS]

# static non-root

[container_image(
    name = "static-nonroot-" + platform,
    base = ":static-" + platform,
    stamp = True,
    user = "%d" % NONROOT,
    workdir = "/home/nonroot",
) for (platform, os, arch) in PLATFORMS]

# base

[container_image(
    name = platform,
    base = ":static-" + platform,
    debs = [
        debian_buster[arch]["libc6"],
        debian_buster[arch]["libssl1.1"],
        debian_buster[arch]["openssl"],
    ],
    stamp = True,
) for (platform, os, arch) in PLATFORMS]

# base non-root

[container_image(
    name = "nonroot-" + platform,
    base = ":" + platform,
    stamp = True,
    user = "%d" % NONROOT,
    workdir = "/home/nonroot",
) for (platform, os, arch) in PLATFORMS]

# base debug

[container_image(
    name = "debug-" + platform,
    base = ":" + platform,
    entrypoint = ["/busybox/bin/sh"],
    layers = ["//private/layer:debug-" + platform],
    stamp = True,
) for (platform, os, arch) in PLATFORMS]

# base debug non-root

[container_image(
    name = "debug-nonroot-" + platform,
    base = ":nonroot-" + platform,
    entrypoint = ["/busybox/bin/sh"],
    layers = ["//private/layer:debug-" + platform],
    stamp = True,
) for (platform, os, arch) in PLATFORMS]
