ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:7.0.0-rc.2-alpine3.16-arm32v7 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=7.0.0-rc.2.22476.2 \
    && wget -O aspnetcore.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-$aspnetcore_version-linux-musl-arm.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='89cb1ea52e630bea5e958dea36ef408b1aa86d52a4f2aafe3de0f8f52920a2c058c6244b12671794ad92d6b46a3bb62d034e321d9f3f1d5cb8d2b0062d1b7ab1' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:7.0.0-rc.2-alpine3.16-arm32v7

# ASP.NET Core version
ENV ASPNET_VERSION=7.0.0-rc.2.22476.2

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
