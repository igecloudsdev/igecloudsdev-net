# escape=`

ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM msint.azurecr.io/private/windows/servercore:ltsc2019-amd64 AS installer

ARG SAS_QUERY_STRING

# Install ASP.NET Core Runtime
RUN powershell -Command `
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        `
        $aspnetcore_version = '6.0.11-servicing.22523.4'; `
        Invoke-WebRequest -OutFile aspnetcore.zip https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22524-2-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.11-win-x64.zip$Env:SAS_QUERY_STRING; `
        $aspnetcore_sha512 = 'd577c00083aa6d85cd6bd92747676285f2a064730f81ad77ce061808f97cf1c5911b130b6b4da0cf83626fc970f8467a7f6361a069ccc2f47bcd9859f654c1fb'; `
        if ((Get-FileHash aspnetcore.zip -Algorithm sha512).Hash -ne $aspnetcore_sha512) { `
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
            exit 1; `
        }; `
        `
        mkdir dotnet/shared/Microsoft.AspNetCore.App; `
        tar -oxzf aspnetcore.zip -C dotnet ./shared/Microsoft.AspNetCore.App; `
        Remove-Item -Force aspnetcore.zip


# ASP.NET Core image
FROM $REPO:6.0.11-windowsservercore-ltsc2019

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.11-servicing.22523.4

COPY --from=installer ["/dotnet/shared/Microsoft.AspNetCore.App", "/Program Files/dotnet/shared/Microsoft.AspNetCore.App"]
