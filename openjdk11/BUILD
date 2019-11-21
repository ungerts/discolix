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
load("//repkg:defs.bzl", "repkg_debs")


# javabase

[container_image(
    name = platform,
    base = "//javabase:" + platform,
    debs = [
        debian_buster_security[arch]["openjdk-11-jdk-headless"],
    ],
    stamp = True,
) for (platform, os, arch) in PLATFORMS]

# javabase non-root

[container_image(
    name = "nonroot-" + platform,
    base = ":" + platform,
    stamp = True,
    user = "%d" % NONROOT,
    workdir = "/home/nonroot",
) for (platform, os, arch) in PLATFORMS]

# javabase debug

[container_image(
    name = "debug-" + platform,
    base = ":" + platform,
    entrypoint = ["/busybox/bin/sh"],
    layers = ["//private/layer:debug-" + platform],
    stamp = True,
) for (platform, os, arch) in PLATFORMS]

# javabase debug non-root

[container_image(
    name = "debug-nonroot-" + platform,
    base = ":nonroot-" + platform,
    entrypoint = ["/busybox/bin/sh"],
    layers = ["//private/layer:debug-" + platform],
    stamp = True,
) for (platform, os, arch) in PLATFORMS]
