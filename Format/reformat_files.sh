#! /bin/sh
#
# Run the following command to retrieve all filenames
#
# `find ../Source/PlatformNeutral/ApiObjects ../Source/PlatformNeutral/Client ../Source/PlatformNeutral/Routes -name "*.[mh]" > list_files_reform.txt`
#
# and then:
#
# `sh reformat_files.sh list_files_reform.txt`
#
if [ -z "$1" ]; then
   echo "specify the file that contains a list of files"
   exit
fi

files=$(cat $1)

for item in $files ; do

  cp $item $item.tmp
  clang\-format $item.tmp > $item
  rm $item.tmp
  sed -i -e 's/*_Nonnull/* _Nonnull/g' $item
  sed -i -e 's/*_Nullable/* _Nullable/g' $item

done