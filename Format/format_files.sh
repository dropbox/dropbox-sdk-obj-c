#!/bin/bash

# e.g. `format_files.sh <srcs_path>`
#

set -euo pipefail

exit_with_message() {
    local message=$1
    local retcode="${2:-0}"

    echo 1>&2 "$message"
    exit "$retcode"
}

exit_with_clang_format_install_message() {
    exit_with_message "Skipping code formatting. Please install clang-format version 7 or greater: 'brew install clang-format'"
}

if ! [ -x "$(command -v clang-format)" ]; then
    exit_with_clang_format_install_message
fi

if ! [ "$(uname -s)" == "Darwin" ]; then
    exit 0
fi

clang_format_version="$(clang-format --version | cut -f3 -w | tail)"
clang_format_version_major=$(awk -F. '{print $1}' <<<"$clang_format_version")
if [ "$clang_format_version_major" -lt 7 ]; then
    exit_with_clang_format_install_message
fi

srcs_path=$1
find "$srcs_path" -type f -name "*[.h|.m]" -exec clang-format -i -style=file "{}" \;
