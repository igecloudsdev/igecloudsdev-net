ARG REPO=mcr.microsoft.com/dotnet/core/runtime
ARG ASPNET_VERSION=5.0.0-preview.5.20228.19

# Installer image
FROM buildpack-deps:buster-curl as installer
ARG ASPNET_VERSION

# Retrieve ASP.NET Core
RUN curl -SL --output aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$ASPNET_VERSION/aspnetcore-runtime-$ASPNET_VERSION-linux-x64.tar.gz \
    && aspnetcore_sha512='dbea5d5ef0cbe7c98c3ead1e4951ab0b0c51dac1ca1f76b71a75658aa5e5c9e7e106e2ee3bc2cd3de0c0326ae8b23f5b458e4c1a7ccea3303f3f2a5a842a0354' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -ozxf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:5.0-buster-slim
ARG ASPNET_VERSION

ENV ASPNET_VERSION $ASPNET_VERSION

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
