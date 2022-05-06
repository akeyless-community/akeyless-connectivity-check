#!/usr/bin/env bash

CRITICAL_SERVICE_CONNECTIVITY_MISSING=false

declare -a akeyless_urls=(
    "https://vault.akeyless.io/status"
    "https://auth.akeyless.io/status"
    "https://audit.akeyless.io/status"
    "https://bis.akeyless.io/status"
    "https://gator.akeyless.io/status"
    "https://kfm1.akeyless.io/status"
    "https://kfm2.akeyless.io/status"
    "https://kfm3.akeyless.io/status"
    "https://kfm4.akeyless.io/status"
    "https://vault-ro.akeyless.io/status"
    "https://auth-ro.akeyless.io/status"
    "https://audit-ro.akeyless.io/status"
    "https://bis-ro.akeyless.io/status"
    "https://gator-ro.akeyless.io/status"
    "https://kfm1-ro.akeyless.io/status"
    "https://kfm2-ro.akeyless.io/status"
    "https://kfm3-ro.akeyless.io/status"
    "https://kfm4-ro.akeyless.io/status"
)

declare -a legacy_akeyless_or_other_urls=(
    "https://rest.akeyless.io"
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
