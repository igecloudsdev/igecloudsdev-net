ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:7.0.0-rc.2-alpine3.16-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=7.0.0-rc.2.22476.2 \
    && wget -O aspnetcore.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-$aspnetcore_version-linux-musl-x64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='b2faa275e8a096ae308e82b653ef8542de171a25c461ccf7744dda4421372def544c7e60bea36c547ce16663e6f26a3f52df30489fc770d8ab819ba58dc00cb4' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:7.0.0-rc.2-alpine3.16-amd64

# ASP.NET Core version
ENV ASPNET_VERSION=7.0.0-rc.2.22476.2

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
