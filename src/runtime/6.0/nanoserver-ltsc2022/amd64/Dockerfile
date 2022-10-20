# escape=`

# Installer image
FROM mcr.microsoft.com/windows/servercore:ltsc2022-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN powershell -Command `
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        `
        $dotnet_version = '6.0.11-servicing.22518.9'; `
        Invoke-WebRequest -OutFile dotnet.zip https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/Runtime/$dotnet_version/dotnet-runtime-6.0.11-win-x64.zip$Env:SAS_QUERY_STRING; `
        $dotnet_sha512 = 'fcf65ca36b0446d5ba550eae556296a18db3e158dbbff23d56dc26e79760441255146025350e9e49915b00b88e9b15b20983dd4cd67e9bb43abd000d44806528'; `
        if ((Get-FileHash dotnet.zip -Algorithm sha512).Hash -ne $dotnet_sha512) { `
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
            exit 1; `
        }; `
        `
        mkdir dotnet; `
        tar -oxzf dotnet.zip -C dotnet; `
        Remove-Item -Force dotnet.zip


# Runtime image
FROM mcr.microsoft.com/windows/nanoserver:ltsc2022-amd64

ENV `
    # Configure web servers to bind to port 80 when present
    ASPNETCORE_URLS=http://+:80 `
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true `
    # .NET Runtime version
    DOTNET_VERSION=6.0.11-servicing.22518.9

# In order to set system PATH, ContainerAdministrator must be used
USER ContainerAdministrator
RUN setx /M PATH "%PATH%;C:\Program Files\dotnet"
USER ContainerUser

COPY --from=installer ["/dotnet", "/Program Files/dotnet"]
