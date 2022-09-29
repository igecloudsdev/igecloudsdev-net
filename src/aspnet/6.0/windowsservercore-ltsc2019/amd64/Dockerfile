# escape=`

ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM mcr.microsoft.com/windows/servercore:ltsc2019-amd64 AS installer

ARG SAS_QUERY_STRING

# Install ASP.NET Core Runtime
RUN powershell -Command `
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        `
        $aspnetcore_version = '6.0.10-servicing.22476.17'; `
        Invoke-WebRequest -OutFile aspnetcore.zip https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.10-win-x64.zip$Env:SAS_QUERY_STRING; `
        $aspnetcore_sha512 = '998b429f29521c421f332504dc381c2c2a90d89266113c0428fd4ee26e047d50f69e0e79f52d02d391dd6bf86a6f757f2ea1239c17368917f455a6041864733a'; `
        if ((Get-FileHash aspnetcore.zip -Algorithm sha512).Hash -ne $aspnetcore_sha512) { `
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
            exit 1; `
        }; `
        `
        mkdir dotnet/shared/Microsoft.AspNetCore.App; `
        tar -oxzf aspnetcore.zip -C dotnet ./shared/Microsoft.AspNetCore.App; `
        Remove-Item -Force aspnetcore.zip


# ASP.NET Core image
FROM $REPO:6.0.10-windowsservercore-ltsc2019

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.10-servicing.22476.17

COPY --from=installer ["/dotnet/shared/Microsoft.AspNetCore.App", "/Program Files/dotnet/shared/Microsoft.AspNetCore.App"]
