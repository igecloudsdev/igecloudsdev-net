ARG REPO=mcr.microsoft.com/dotnet/core/runtime
ARG ASPNET_VERSION=5.0.0-preview.5.20228.19

# Installer image
FROM arm64v8/buildpack-deps:buster-curl as installer
ARG ASPNET_VERSION

# Retrieve ASP.NET Core
RUN curl -SL --output aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$ASPNET_VERSION/aspnetcore-runtime-$ASPNET_VERSION-linux-arm64.tar.gz \
    && aspnetcore_sha512='8c71d50907cffb2b99f9c14c0974fb18ed2e0799570bcfedd5f7c19a0ce569504a6a96d102286248a0da76d919fc43ff1782b9ad65c5944c44d12246a45a4b71' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -ozxf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:5.0-buster-slim-arm64v8
ARG ASPNET_VERSION

ENV ASPNET_VERSION $ASPNET_VERSION

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
