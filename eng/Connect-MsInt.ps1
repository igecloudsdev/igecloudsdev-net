[cmdletbinding()]
param(
    [string]
    $ServicePrincipalName,
    [string]
    $ServicePrincipalTenant,
    [string]
    $ServicePrincipalSecret
)

$registry = "msint.azurecr.io"
$username = "1a1c2aff-902a-478e-b22e-5a76b4b76d51"
$tenant = "33e01921-4d64-4f8c-a055-5bdaffd5e33d"

echo $env:PATH
Get-Command -CommandType Application

#$path = "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin\az.cmd"

az login --service-principal --username $ServicePrincipalName --tenant $ServicePrincipalTenant -p $ServicePrincipalSecret

$tempFile = "$Env:Temp/dotnet-docker-msint-cert-$([System.IO.Path]::GetRandomFileName()).pem"
az keyvault secret download -n MSINT-SPN-CERT --vault-name msint-community -f $tempFile

az login --service-principal --use-cert-sn-issuer --username $username --tenant $tenant -p $tempFile
az acr login -n $registry
