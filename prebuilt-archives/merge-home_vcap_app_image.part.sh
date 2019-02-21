#!/bin/bash

set -e

# folder to home_vcap_app_image.tar.gz.part*
source_dir=$1
if [ -z $1 ]; then 	source_dir="."; fi
pushd $source_dir
abs_source_dir=`pwd`
echo "abs_source_dir:$abs_source_dir"

popd

part_file_name="home_vcap_app_image.tar.gz.part"
merged_file_name="home_vcap_app_image.tar.gz"

if [ $(find $abs_source_dir -maxdepth 1 -name "${part_file_name}*" -type f | wc -l ) -eq 0 ]; then
    echo "[WARN] no target file named with ${part_file_name}* found in $abs_source_dir"
    exit 0
fi



# merge home_vcap_app file
echo "# merging $abs_source_dir ..."
ls -alh ${abs_source_dir}/${part_file_name}*
cat ${abs_source_dir}/${part_file_name}* > "$abs_source_dir/${merged_file_name}"


