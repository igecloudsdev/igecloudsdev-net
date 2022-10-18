#!/usr/bin/env sh

set -e
set -u

echo "Logging in with .NET service principal..."

az login --service-principal --username $MSINT_SERVICEPRINCIPALNAME --tenant $MSINT_SERVICEPRINCIPALTENANT -p $APP_DOTNETDOCKERMSINTREGISTRY_CLIENT_SECRET

registry="msint.azurecr.io"
username="1a1c2aff-902a-478e-b22e-5a76b4b76d51"
tenant="33e01921-4d64-4f8c-a055-5bdaffd5e33d"

echo "Downloading certificate..."
tempFile="/tmp/azure-cert.pem"
az keyvault secret download -n MSINT-SPN-CERT --vault-name msint-community -f $tempFile

echo "Logging in with MAR service principal..."
az login --service-principal --use-cert-sn-issuer --username $username --tenant $tenant -p $tempFile
az acr login -n $registry

echo "Executing Image Builder..."
set +e
/image-builder/Microsoft.DotNet.ImageBuilder $@
if [ $? -ne 0 ]; then
    imageBuilderFailed=1
else
    imageBuilderFailed=0
fi
set -e

echo "Logging out of Docker..."
docker logout $registry

echo "Logging out of Azure..."
az logout --username $username

echo "Deleting certificate file..."
rem $tempFile

if [ $imageBuilderFailed -ne 0 ]; then
    exit 1
fi
