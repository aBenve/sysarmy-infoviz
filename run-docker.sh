#!/bin/bash

docker run --rm -v $(pwd):/project --network host -u$(id -u):$(id -g) -it ghcr.io/observablehq/framework-runtime npm run dev
