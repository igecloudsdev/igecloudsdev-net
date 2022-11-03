# escape=`

# Installer image
FROM msint.azurecr.io/private/windows/servercore:1809-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN powershell -Command `
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        `
        $dotnet_version = '6.0.11-servicing.22523.4'; `
        Invoke-WebRequest -OutFile dotnet.zip https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22524-2-internal/Runtime/$dotnet_version/dotnet-runtime-6.0.11-win-x64.zip$Env:SAS_QUERY_STRING; `
        $dotnet_sha512 = '63f33c7e4995c8aecd68148f6c6eb41ed72df8b7668fc510ce205cdf6060d398068657c3a392b799a8bba704a8f10ed1700fecffe932e6f13d3a44b18180e8ff'; `
        if ((Get-FileHash dotnet.zip -Algorithm sha512).Hash -ne $dotnet_sha512) { `
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
            exit 1; `
        }; `
        `
        mkdir dotnet; `
        tar -oxzf dotnet.zip -C dotnet; `
        Remove-Item -Force dotnet.zip


# Runtime image
FROM msint.azurecr.io/private/windows/nanoserver:1809-amd64

ENV `
    # Configure web servers to bind to port 80 when present
    ASPNETCORE_URLS=http://+:80 `
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true `
    # .NET Runtime version
    DOTNET_VERSION=6.0.11-servicing.22523.4

# In order to set system PATH, ContainerAdministrator must be used
USER ContainerAdministrator
RUN setx /M PATH "%PATH%;C:\Program Files\dotnet"
USER ContainerUser

COPY --from=installer ["/dotnet", "/Program Files/dotnet"]
