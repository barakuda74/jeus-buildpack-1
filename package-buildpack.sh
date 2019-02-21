#!/bin/bash

set -e

# folder to home_vcap_app_image.tar.gz.part*
source_dir=$1
if [ -z $1 ]; then 	source_dir="."; fi
pushd $source_dir
abs_source_dir=`pwd`


source ${abs_source_dir}/.envrc

#gem install bundler -v '< 2'
#bundle install --path vendor/bundle

echo "merging home_vcap_app file for conatiner"
chmod +x ${abs_source_dir}/prebuilt-archives/merge-home_vcap_app_image.part.sh
${abs_source_dir}/prebuilt-archives/merge-home_vcap_app_image.part.sh ${abs_source_dir}/prebuilt-archives/home_vcap_app_image

echo "packaging buildpack"
bundle exec buildpack-packager --cached

echo "cleanup "
rm -rf ${abs_source_dir}/prebuilt-archives/home_vcap_app_image/home_vcap_app_image.tar.gz

echo "packaging complete "

echo "run cf-upload-buildpack.sh"
