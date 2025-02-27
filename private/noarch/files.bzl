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

NOBODY = 65534
NONROOT = 65532

def _pad(max_len, text, extra = "    "):
    pad_spcs = max_len - len(text)
    if pad_spcs <= 0:
        return extra
    return "".join([" " for i in range(0, pad_spcs)]) + extra

def _nsswitch_conf_file_impl(ctx):
    doc = """# /etc/nsswitch.conf
#
# generated by bazel
#
# Example configuration of GNU Name Service Switch functionality.
# If you have the `glibc-doc-reference' and `info' packages installed, try:
# `info libc "Name Service Switch"' for information about this file.
\n"""
    max_len = max([len(key) for key in ctx.attr.entries.keys()])
    data = doc + "".join(["%s:%s%s\n" % (
        entry[0],  # db name
        _pad(max_len, entry[0]),
        entry[1],  # db service spec
    ) for entry in ctx.attr.entries.items()])
    nsswitch_file = ctx.actions.declare_file(ctx.attr.name)
    ctx.actions.write(output = nsswitch_file, content = data)
    return DefaultInfo(files = depset([nsswitch_file]))

nsswitch_conf_file = rule(
    attrs = {
        "entries": attr.string_dict(
            allow_empty = False,
        ),
    },
    executable = False,
    implementation = _nsswitch_conf_file_impl,
)

def _os_release_file_impl(ctx):
    data = """PRETTY_NAME=\"%s\"
NAME=\"%s\"
VERSION_ID=\"%s\"
VERSION=\"%s\"
VERSION_CODENAME=%s
ID=%s
HOME_URL=\"%s\"
SUPPORT_URL=\"%s\"
BUG_REPORT_URL=\"%s\"\n""" % (
        ctx.attr.pretty_name,
        ctx.attr.release_name,
        ctx.attr.version_id,
        ctx.attr.version,
        ctx.attr.version_codename,
        ctx.attr.id,
        ctx.attr.home_url,
        ctx.attr.support_url,
        ctx.attr.bug_report_url,
    )
    release_file = ctx.actions.declare_file(ctx.attr.name)
    ctx.actions.write(output = release_file, content = data)
    return DefaultInfo(files = depset([release_file]))

os_release_file = rule(
    attrs = {
        "pretty_name": attr.string(mandatory = True),
        "release_name": attr.string(mandatory = True),
        "version_id": attr.string(mandatory = True),
        "version": attr.string(mandatory = True),
        "version_codename": attr.string(mandatory = True),
        "id": attr.string(mandatory = True),
        "home_url": attr.string(default = ""),
        "support_url": attr.string(default = ""),
        "bug_report_url": attr.string(default = ""),
    },
    implementation = _os_release_file_impl,
)
