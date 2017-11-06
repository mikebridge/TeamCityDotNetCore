#!/bin/bash

# exit on error
set -e

# attempt to warm these up
curl -s http://XXXXXXXXXXXXXXX.azurewebsites.net > /dev/null
curl -s http://YYYYYYYYYYYYYYY.azurewebsites.net > /dev/null

# this fixes weird integer error message
# clear is from https://github.com/Azure/azure-cli/issues/2548
az account clear

az login --service-principal -u XXXXXXXXXXXXXXX

az webapp deployment slot swap --resource-group XXXXXXXXX --name xxxx-xxx --slot xxxxxxxxxxx --target-slot production

az webapp deployment slot swap --resource-group xxxxxx --name xxxx --slot xxxx --target-slot production



