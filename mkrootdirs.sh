#!/bin/bash

ROOT=/mnt/lfs

DIRS="bin boot dev etc home opt run srv tmp usr var"

echo "Creating root directories..."

pushd $ROOT

for dir in $DIRS; do
  if [ ! -d $dir ]; then
    mkdir -v $dir
  fi
done

popd

echo "Done."