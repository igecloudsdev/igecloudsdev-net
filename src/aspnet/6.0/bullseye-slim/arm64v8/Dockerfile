ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM arm64v8/buildpack-deps:bullseye-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.11-servicing.22523.4 \
    && curl -fSL --output aspnetcore.tar.gz https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22524-2-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.11-linux-arm64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='cf2a469cc2364358e0cd51640e9a614747e60724a99d5151dbd346eaad3779939f741f0cd0a752774a6df51c3e2af5a49ba8e4c5ba7ac02eda192cb7b73d85f7' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:6.0.11-bullseye-slim-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.11-servicing.22523.4

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
