#!/bin/sh
# e.g. `sh reformat_files.sh <srcs_path> <path_to_clang_format>`
#

srcs_path=$1
path_to_clang_format=$2

clang_format_cmd="$path_to_clang_format/clang-format"

if [ -z "$path_to_clang_format" ]; then
    clang_format_cmd="clang-format"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    find "$srcs_path" -type f -name "*[.h|.m]" | xargs "$clang_format_cmd" -i
fi
