#!/usr/bin/env bash

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
(cd "$THIS_DIR" && rm -rf test && cp -r ../test .)
docker build -t cryolite/test-my-vector .
