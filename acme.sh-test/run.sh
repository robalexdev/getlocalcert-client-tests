#!/bin/bash

source prod.env
./.acme.sh/acme.sh --issue --dns dns_acmedns -d 1.localhostcert.net --staging

