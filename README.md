# Integration examples

This repo provides examples for how to issue HTTPS certificates for [getlocalcert](https://www.getlocalcert.net) subdomain names using various ACME clients.

You can use the example code as a quick start for your own projects. For more details, please see the [documentation site](https://docs.getlocalcert.net/).

## Examples

### Caddy

[![Register and Issue using Caddy](https://github.com/robalexdev/getlocalcert-client-tests/actions/workflows/caddy.yml/badge.svg)](https://github.com/robalexdev/getlocalcert-client-tests/actions/workflows/caddy.yml)

[Sample code](/examples/caddy/)

### LEGO

[![Register and Issue using LEGO](https://github.com/robalexdev/getlocalcert-client-tests/actions/workflows/lego.yml/badge.svg)](https://github.com/robalexdev/getlocalcert-client-tests/actions/workflows/lego.yml)

[Sample code](/examples/lego/)

[![Issue using delegate domain](https://github.com/robalexdev/getlocalcert-client-tests/actions/workflows/lego-delegate.yml/badge.svg)](https://github.com/robalexdev/getlocalcert-client-tests/actions/workflows/lego-delegate.yml)

[Sample code](/examples/lego-delegate-domain/)

### Traefik

[![Register and Issue using Traefik](https://github.com/robalexdev/getlocalcert-client-tests/actions/workflows/traefik.yml/badge.svg)](https://github.com/robalexdev/getlocalcert-client-tests/actions/workflows/traefik.yml)

[Sample code](/examples/traefik/)

### acme.sh

[![Register and Issue using acme.sh](https://github.com/robalexdev/getlocalcert-client-tests/actions/workflows/acmesh.yml/badge.svg)](https://github.com/robalexdev/getlocalcert-client-tests/actions/workflows/acmesh.yml)

[Sample code](/examples/acme.sh/)

[![Issue cert for an existing domain](https://github.com/robalexdev/getlocalcert-client-tests/actions/workflows/existing-domain.yml/badge.svg)](https://github.com/robalexdev/getlocalcert-client-tests/actions/workflows/existing-domain.yml)

[Sample code](.github/workflows/existing-domain.yml)

## Testing

A daily workflow runs to run the example code and issue a Let's Encrypt staging certificate.
This helps detect incompatibility between the ACME clients and the getlocalcert service.

### Running tests locally

The tests can be run locally using [act](https://github.com/nektos/act).

    ./act -l
    ./act -s ACMEDNS_EMAIL=you@example.com -j register-and-issue

Sometimes we need to customize the container:

    ./act -s ACMEDNS_EMAIL=you@example.com -j lego-register-and-issue -P ubuntu-latest=golang:latest

A couple of the tests don't work with act.
The Traefik example ends up being a tricky docker-in-docker example, which would be too ugly to support.
