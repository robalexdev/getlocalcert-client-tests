# Client Testing and Examples

This repo provides examples for how to issue HTTPS certificates for [getlocalcert](https://www.getlocalcert.net) domain names using various ACME clients.

## Examples

See the examples/ folder.

## Testing

A daily workflow runs to register an anonymous subdomain and issue a Let's Encrypt staging certificate.
This helps detect incompatibility between the ACME clients and the getlocalcert service.

### Testing locally

The tests can be run locally using [act](https://github.com/nektos/act).

    ./act -l
    ./act -s ACMEDNS_EMAIL=you@example.com -j register-and-issue

Sometimes we need to customize the container:

    ./act -s ACMEDNS_EMAIL=you@example.com -j lego-register-and-issue -P ubuntu-latest=golang:latest

