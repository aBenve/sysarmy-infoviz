#!/bin/bash

docker build --tag sysarmy-infoviz .
docker run --rm -v $(pwd):/project -p3000:3000 -it sysarmy-infoviz:latest npx observable preview --host 0.0.0.0
