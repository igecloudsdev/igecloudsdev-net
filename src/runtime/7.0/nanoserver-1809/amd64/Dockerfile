# escape=`

# Installer image
FROM mcr.microsoft.com/windows/servercore:1809-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN powershell -Command `
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        `
        $dotnet_version = '7.0.0-rtm.22513.8'; `
        Invoke-WebRequest -OutFile dotnet.zip https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-7.0.0-win-x64.zip$Env:SAS_QUERY_STRING; `
        $dotnet_sha512 = '75c3fc9c4ea92bec78c82abdd84587bb8c211f7d09fc38d058b1211b5ea1409b62d8b388c2ec4714a4dbd5ab187ebbb356a7647f1d8136844accbd310a84a411'; `
        if ((Get-FileHash dotnet.zip -Algorithm sha512).Hash -ne $dotnet_sha512) { `
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
            exit 1; `
        }; `
        `
        mkdir dotnet; `
        tar -oxzf dotnet.zip -C dotnet; `
        Remove-Item -Force dotnet.zip


# Runtime image
FROM mcr.microsoft.com/windows/nanoserver:1809-amd64

ENV `
    # Configure web servers to bind to port 80 when present
    ASPNETCORE_URLS=http://+:80 `
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true `
    # .NET Runtime version
    DOTNET_VERSION=7.0.0-rtm.22513.8

# In order to set system PATH, ContainerAdministrator must be used
USER ContainerAdministrator
RUN setx /M PATH "%PATH%;C:\Program Files\dotnet"
USER ContainerUser

COPY --from=installer ["/dotnet", "/Program Files/dotnet"]
