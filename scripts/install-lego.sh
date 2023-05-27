#!/bin/bash

set -e

curl -s https://api.github.com/repos/go-acme/lego/releases/latest > latest.txt
DOWNLOAD_URL=$(cat latest.txt | jq -r .assets[].browser_download_url | grep "_linux_amd64.tar.gz")
wget ${DOWNLOAD_URL}
tar xvf *_linux_amd64.tar.gz

