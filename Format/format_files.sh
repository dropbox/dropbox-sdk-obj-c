#!/bin/sh
# e.g. `sh reformat_files.sh <srcs_path>`
#

srcs_path=$1

if [[ "$OSTYPE" == "darwin"* ]]; then
    find "$srcs_path" -type f -name "*[.h|.m]" | xargs ./clang-format -i -style=file
fi
