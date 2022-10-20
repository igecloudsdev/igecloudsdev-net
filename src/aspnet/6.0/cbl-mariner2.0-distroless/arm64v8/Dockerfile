ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM mcr.microsoft.com/cbl-mariner/base/core:2.0 AS installer

ARG SAS_QUERY_STRING

RUN tdnf install -y \
        ca-certificates-microsoft \
        gzip \
        tar \
    && tdnf clean all

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.11-servicing.22518.17 \
    && curl -fSL --output aspnetcore.tar.gz https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.11-linux-arm64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='f706bb19593be51d244302d369189da73d705f15c8822869b58730918c4fa485d707b8b689b3f07b38b48c3f33cbded419647abbf9788e8d6c78a032a9969be3' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf aspnetcore.tar.gz -C /dotnet ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:6.0.11-cbl-mariner2.0-distroless-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.11-servicing.22518.17

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]
