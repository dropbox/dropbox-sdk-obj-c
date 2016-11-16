#! /bin/sh
#
# Run the following command to retrieve all filenames
#
# `find ../Source/ -iname "*.[mh]" > list_files_reformat.txt`
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
    
    sed -i '' -e 's/*_Nonnull/* _Nonnull/g' -e 's/*_Nullable/* _Nullable/g' -e 's/@property(/@property (/g' $item
    
done
