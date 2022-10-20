ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM mcr.microsoft.com/cbl-mariner/base/core:1.0 AS installer

ARG SAS_QUERY_STRING

RUN tdnf install -y \
        ca-certificates-microsoft \
    && tdnf clean all

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.11-servicing.22518.17 \
    && curl -fSL --output aspnetcore.tar.gz https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.11-linux-x64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='d771a753302ce6444bd36c009626c9cf3564bf6e6d3d9ccbe7d73cda802fbaa0d021f6e6064e254279cdcd6b2c10cca4856dbccd9d5373c99b697b0a107e675e' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf aspnetcore.tar.gz -C /dotnet ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:6.0.11-cbl-mariner1.0-distroless-amd64

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.11-servicing.22518.17

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]
