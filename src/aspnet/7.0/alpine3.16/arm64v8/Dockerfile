ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:7.0.0-rc.2-alpine3.16-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=7.0.0-rc.2.22476.2 \
    && wget -O aspnetcore.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-$aspnetcore_version-linux-musl-arm64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='740a44123fffe94cea509369b58f08833f2c7206c176bede59f7ae2c9e17efc9fede38ccc11e5048bb0057a33ee80a78cca024deb36db0ea979f43874dbef68c' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:7.0.0-rc.2-alpine3.16-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=7.0.0-rc.2.22476.2

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
