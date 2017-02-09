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

for item in $1 ; do
    cp $item $item.tmp
    
    clang\-format $item.tmp > $item

    rm $item.tmp
    
    sed -i '' -e 's/*_Nonnull/* _Nonnull/g' -e 's/*_Nullable/* _Nullable/g' -e 's/@property(/@property (/g' $item
    
done
