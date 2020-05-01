# escape=`

ARG REPO=mcr.microsoft.com/dotnet/core/runtime
ARG ASPNET_VERSION=5.0.0-preview.5.20228.19

# Installer image
FROM mcr.microsoft.com/windows/servercore:1903 AS installer
ARG ASPNET_VERSION

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install ASP.NET Core Runtime
RUN Invoke-WebRequest -OutFile aspnetcore.zip https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$Env:ASPNET_VERSION/aspnetcore-runtime-$Env:ASPNET_VERSION-win-x64.zip; `
    $aspnetcore_sha512 = 'b7ec648ebafc53c69621f72844feaadaa14da2e38c847639a282df38ec509b4f9d3945dc935ca226cb8d3ddf49bf56aba2bd26d58e2071ac3d48ed0bc34e5df8'; `
    if ((Get-FileHash aspnetcore.zip -Algorithm sha512).Hash -ne $aspnetcore_sha512) { `
        Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
        exit 1; `
    }; `
    `
    Expand-Archive aspnetcore.zip -DestinationPath dotnet; `
    Remove-Item -Force aspnetcore.zip


# Runtime image
FROM $REPO:5.0-nanoserver-1903
ARG ASPNET_VERSION

ENV ASPNET_VERSION $ASPNET_VERSION

COPY --from=installer ["/dotnet/shared/Microsoft.AspNetCore.App", "/Program Files/dotnet/shared/Microsoft.AspNetCore.App"]
