#!/bin/bash

# This project uses lowercase variable names and otherwise aims to follow
# the Google Style Guide for shell scripts, found here:
# https://google-styleguide.googlecode.com/svn/trunk/shell.xml

# Define config_file. We don't use quotes here because 
# we want tilde expansion.
config_file=~/.ssh/config

dts=$(date +%m%d%Y_%H%M)

# Backup the config file
if [[ -e $config_file ]]; then
  config_file_name=$(basename $config_file)
  config_file_dir=$(dirname $config_file)
  cd $config_file_dir
  mv $config_file_name "${config_file_name}_${dts}"
fi

# Begin writing to $config_file
touch $config_file
> $config_file
echo "# Automatic config built from ~/.ssh/config.d by $0" >> $config_file
echo >> $config_file

for f in $(ls ~/.ssh/config.d/*.config); do
  echo "###################" >> $config_file
  echo "# ${f}" >> $config_file
  echo >> $config_file
  cat $f >> $config_file
  echo >> $config_file
done

echo "Original config file was copied to ${config_file_name}_${dts}" 1>&2
echo "New config file compiled from ~/.ssh/config.d/*.config and written to ~/.ssh/config" 1>&2

