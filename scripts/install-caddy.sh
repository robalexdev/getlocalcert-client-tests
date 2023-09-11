#!/bin/bash

set -e

go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
xcaddy build --with github.com/caddy-dns/acmedns

