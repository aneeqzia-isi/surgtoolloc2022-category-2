#!/usr/bin/env bash

./build.sh

docker save surgtoolloc_det | gzip -c > surgtoolloc_det.tar.gz
