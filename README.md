# Akeyless Service Connectivity Checker

This script verifies connectivity to various Akeyless services, crucial in scenarios when ensuring that applications and systems can properly interact with the Akeyless Vault.

## Description

The bash script iterates through a list of essential Akeyless services and attempts to reach them through a cURL command. If a service is reachable, it returns a message indicating that the service is up and running. If a service is not reachable, it flags this as a critical error.

Additionally, the script checks a list of legacy or secondary Akeyless services, or other URLs that Akeyless might depend on. This script performs a different kind of check (by looking for specific HTTP response codes), and outputs similar status messages.

## Requirements

- Bash
- cURL

## Install

Run the script

```sh
./check_connectivity.sh
```

Run externally

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/akeyless-community/akeyless-connectivity-check/main/check_connectivity.sh)"
```

## Setup

1. Save the script to a `.sh` file in your preferred directory.
2. Open a terminal and navigate to the directory where you saved the script.
3. Run `chmod +x check_connectivity.sh` to make the script executable, replacing `check_connectivity.sh` with the name of your script.
4. Run the script with `./check_connectivity.sh`.

## Usage

The script can be customized by changing the `AKEYLESS_DOMAIN` variable. 

For a single-tenant environment, you should use the sub-domain like this:

```bash
AKEYLESS_DOMAIN=".mycorp.akeyless.io"
```

You can also modify the arrays `akeyless_urls` and `legacy_akeyless_or_other_urls` to add or remove services as required. The script will automatically iterate over these arrays.

## Output

The script will output a series of messages indicating the status of each service. If a service is not reachable, the script will echo a message with the problematic URL.

## Disclaimer

The reachability of a service does not necessarily imply the correct functioning of the service. This script is intended as a basic check of network connectivity and the services' availability to respond to requests. For comprehensive service health checks, refer to the service's official monitoring tools or guidelines.
