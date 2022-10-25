# escape=`

# Installer image
FROM mcr.microsoft.com/windows/servercore:ltsc2022-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN powershell -Command `
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        `
        $dotnet_version = '7.0.0-rtm.22518.5'; `
        Invoke-WebRequest -OutFile dotnet.zip https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22521-12-internal/Runtime/$dotnet_version/dotnet-runtime-7.0.0-win-x64.zip$Env:SAS_QUERY_STRING; `
        $dotnet_sha512 = '96bea9aa573326af8fa002a43e73115f0fed8446091a3e865796c4e9464b7b0ed7d953d32ce63377ac0994cc61f462215f7e2a426551e8ec5b891c50341e6498'; `
        if ((Get-FileHash dotnet.zip -Algorithm sha512).Hash -ne $dotnet_sha512) { `
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
            exit 1; `
        }; `
        `
        mkdir dotnet; `
        tar -oxzf dotnet.zip -C dotnet; `
        Remove-Item -Force dotnet.zip


# Runtime image
FROM mcr.microsoft.com/windows/servercore:ltsc2022-amd64

ENV `
    # Configure web servers to bind to port 80 when present
    ASPNETCORE_URLS=http://+:80 `
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true `
    # .NET Runtime version
    DOTNET_VERSION=7.0.0-rtm.22518.5

RUN setx /M PATH "%PATH%;C:\Program Files\dotnet"

COPY --from=installer ["/dotnet", "/Program Files/dotnet"]
