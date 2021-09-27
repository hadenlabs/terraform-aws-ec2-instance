#!/usr/bin/env bash
set -x
curl https://raw.githubusercontent.com/hadenlabs/build-tools/develop/provision/scripts/docker/install.sh -o docker-install.sh

chmod +x docker-install.sh

sudo ./docker-install.sh
