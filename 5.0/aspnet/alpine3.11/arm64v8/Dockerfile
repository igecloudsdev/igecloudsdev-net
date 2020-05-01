ARG REPO=mcr.microsoft.com/dotnet/core/runtime
FROM $REPO:5.0-alpine3.11-arm64v8

# Install ASP.NET Core
ENV ASPNET_VERSION 5.0.0-preview.5.20228.19

RUN wget -O aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$ASPNET_VERSION/aspnetcore-runtime-$ASPNET_VERSION-linux-musl-arm64.tar.gz \
    && aspnetcore_sha512='daa5ff36c7a6da1cdc3dc90e15152ce030ec8e4a1b806db031c1a66e8761bab015e36970ae3d759bdf99ae4a1afcfc098bc9fdc72841875b63c69ef3110bd340' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -ozxf aspnetcore.tar.gz -C /usr/share/dotnet ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz
