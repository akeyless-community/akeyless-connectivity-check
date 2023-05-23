#!/usr/bin/env bash

CRITICAL_SERVICE_CONNECTIVITY_MISSING=false

# For a single-tenant environment you should use 
# the sub-domain like this:
# AKEYLESS_DOMAIN=".mycorp.akeyless.io"
AKEYLESS_DOMAIN=".akeyless.io"

declare -a akeyless_urls=(
    "https://vault${AKEYLESS_DOMAIN}/status"
    "https://auth${AKEYLESS_DOMAIN}/status"
    "https://audit${AKEYLESS_DOMAIN}/status"
    "https://bis${AKEYLESS_DOMAIN}/status"
    "https://gator${AKEYLESS_DOMAIN}/status"
    "https://kfm1${AKEYLESS_DOMAIN}/status"
    "https://kfm2${AKEYLESS_DOMAIN}/status"
    "https://kfm3${AKEYLESS_DOMAIN}/status"
    "https://kfm4${AKEYLESS_DOMAIN}/status"
    "https://vault-ro${AKEYLESS_DOMAIN}/status"
    "https://auth-ro${AKEYLESS_DOMAIN}/status"
    "https://audit-ro${AKEYLESS_DOMAIN}/status"
    "https://bis-ro${AKEYLESS_DOMAIN}/status"
    "https://gator-ro${AKEYLESS_DOMAIN}/status"
    "https://kfm1-ro${AKEYLESS_DOMAIN}/status"
    "https://kfm2-ro${AKEYLESS_DOMAIN}/status"
    "https://kfm3-ro${AKEYLESS_DOMAIN}/status"
    "https://kfm4-ro${AKEYLESS_DOMAIN}/status"
    ""
)

declare -a legacy_akeyless_or_other_urls=(
    "https://rest${AKEYLESS_DOMAIN}"
    "https://akeyless-cli.s3.us-east-2.amazonaws.com"
    "https://akeylessservices.s3.us-east-2.amazonaws.com"
    "https://sqs.us-east-2.amazonaws.com"
)

for url in "${akeyless_urls[@]}"
do
    if curl -sSf $url > /dev/null; then
        echo "Akeyless Service is up and running and reachable : $url"
    else
        echo "Akeyless Service is NOT reachable : $url"
        CRITICAL_SERVICE_CONNECTIVITY_MISSING=true
    fi
done

for url in "${legacy_akeyless_or_other_urls[@]}"
do
    INITIAL_RESULT=$(curl -LI $url -o /dev/null -w '%{http_code}\n' -s)
    RESULT=$(( $INITIAL_RESULT + 0 ))
    case $RESULT in
        200 | 403 | 404 | 405)
            echo "Akeyless dependandant service is up and running and reachable : $url"
            ;;

        *)
            echo "Akeyless dependandant service is NOT reachable (Status Code : ${RESULT}) : $url"
            CRITICAL_SERVICE_CONNECTIVITY_MISSING=true
            ;;
    esac
done
