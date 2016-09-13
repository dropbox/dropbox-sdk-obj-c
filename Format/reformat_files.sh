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

echo "Reformating source..."

if [ -z "$1" ]; then
   echo "specify the file that contains a list of files"
   exit
fi

files=$(cat $1)

for item in $files ; do

    cp $item $item.tmp
    
    clang\-format $item.tmp > $item
    
    sed -i -e 's/*_Nonnull/* _Nonnull/g' $item
    sed -i -e 's/*_Nullable/* _Nullable/g' $item
    sed -i -e 's/@property(/@property (/g' $item
    
    rm $item.tmp
done

find ../ -type f -name '*-e' -delete