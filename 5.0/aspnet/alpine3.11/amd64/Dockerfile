ARG REPO=mcr.microsoft.com/dotnet/core/runtime
FROM $REPO:5.0-alpine3.11

# Install ASP.NET Core
ENV ASPNET_VERSION 5.0.0-preview.5.20228.19

RUN wget -O aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$ASPNET_VERSION/aspnetcore-runtime-$ASPNET_VERSION-linux-musl-x64.tar.gz \
    && aspnetcore_sha512='1c82a9d03de1ba11878c5ff812cb19c8b5ad9b7270d905f3e3b8be8237eb4cfb2a5fea89d65c60f76ca62f36f04a8d84746dfee955ab80c223e6007d0ca9b608' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -ozxf aspnetcore.tar.gz -C /usr/share/dotnet ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz
