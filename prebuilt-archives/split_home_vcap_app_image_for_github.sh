#!/bin/bash
## splited due to file size limit of 100MB in github

set -e

# folder to home_vcap_app_image.tar.gz.part*
source_dir=$1
if [ -z $1 ]; then 	source_dir="."; fi
pushd $source_dir
abs_source_dir=`pwd`
popd

part_file_name="home_vcap_app_image.tar.gz.part"
merged_file_name="home_vcap_app_image.tar.gz"

#echo "[root] checking apt files in $APT_DIR"
if [ $(find $abs_source_dir -maxdepth 1 -name "${merged_file_name}" -type f | wc -l ) -eq 0 ]; then
    echo "[WARN] no target file named with ${merged_file_name} found in $abs_source_dir"
    exit 0
fi

echo "spliting $merged_file_name"

split -b 100000000 "${abs_source_dir}/${merged_file_name}" "${abs_source_dir}/${part_file_name}"

echo "spliting complete "
ls -al "${abs_source_dir}"

