# escape=`

ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM mcr.microsoft.com/windows/servercore:ltsc2022-amd64 AS installer

ARG SAS_QUERY_STRING

# Install ASP.NET Core Runtime
RUN powershell -Command `
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        `
        $aspnetcore_version = '6.0.10-servicing.22469.29'; `
        Invoke-WebRequest -OutFile aspnetcore.zip https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.10-win-x64.zip$Env:SAS_QUERY_STRING; `
        $aspnetcore_sha512 = 'cf399340a3c6e25b44afa7089dcae151321491507837a74936849bd03ab7f69498b826cabb4b585f8d894d0671e2eec0d5f11b51907fab191eb6587603f54044'; `
        if ((Get-FileHash aspnetcore.zip -Algorithm sha512).Hash -ne $aspnetcore_sha512) { `
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
            exit 1; `
        }; `
        `
        mkdir dotnet/shared/Microsoft.AspNetCore.App; `
        tar -oxzf aspnetcore.zip -C dotnet ./shared/Microsoft.AspNetCore.App; `
        Remove-Item -Force aspnetcore.zip


# ASP.NET Core image
FROM $REPO:6.0.10-windowsservercore-ltsc2022

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.10-servicing.22469.29

COPY --from=installer ["/dotnet/shared/Microsoft.AspNetCore.App", "/Program Files/dotnet/shared/Microsoft.AspNetCore.App"]
