# escape=`

# Installer image
FROM mcr.microsoft.com/windows/servercore:ltsc2022-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN powershell -Command `
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        `
        $dotnet_version = '6.0.10-servicing.22469.10'; `
        Invoke-WebRequest -OutFile dotnet.zip https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.10-win-x64.zip$Env:SAS_QUERY_STRING; `
        $dotnet_sha512 = '1bff3e8a7262b40c8e6036917154f76150455df1655547b69efe9fb101c4187989aba631830b71c709210ef6c0faf58da4d26ab0304e075025b2d0eb562bb6a6'; `
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
    DOTNET_VERSION=6.0.10-servicing.22469.10

RUN setx /M PATH "%PATH%;C:\Program Files\dotnet"

COPY --from=installer ["/dotnet", "/Program Files/dotnet"]
