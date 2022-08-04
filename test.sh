#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

bash build.sh

VOLUME_SUFFIX=$(dd if=/dev/urandom bs=32 count=1 | md5sum | cut --delimiter=' ' --fields=1)
MEM_LIMIT="4g"  # Maximum is currently 30g, configurable in your algorithm image settings on grand challenge

docker volume create surgtoolloc_det-output-$VOLUME_SUFFIX

# Do not change any of the parameters to docker run, these are fixed
docker run --rm \
        --memory="${MEM_LIMIT}" \
        --memory-swap="${MEM_LIMIT}" \
        --network="none" \
        --cap-drop="ALL" \
        --security-opt="no-new-privileges" \
        --shm-size="128m" \
        --pids-limit="256" \
        -v $SCRIPTPATH/test/:/input/ \
        -v surgtoolloc_det-output-$VOLUME_SUFFIX:/output/ \
        surgtoolloc_det

docker run --rm \
        -v surgtoolloc_det-output-$VOLUME_SUFFIX:/output/ \
        python cat /output/results.json | python -m json.tool
        python:3.9-slim cat /output/results.json | python -m json.tool

docker run --rm \
        -v surgtoolloc_det-output-$VOLUME_SUFFIX:/output/ \
        -v $SCRIPTPATH/test/:/input/ \
        -v $SCRIPTPATH/:/tmp/ \
        python:3.9-slim python -c "import json, sys; f1 = json.load(open('/output/surgical-tools.json')); f2 = json.load(open('/tmp/expected_output_detection.json')); sys.exit(f1 != f2);"

if [ $? -eq 0 ]; then
    echo "Tests successfully passed..."
else
    echo "Expected output was not found..."
fi

docker volume rm surgtoolloc_det-output-$VOLUME_SUFFIX
