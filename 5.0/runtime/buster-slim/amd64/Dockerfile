ARG REPO=mcr.microsoft.com/dotnet/core/runtime-deps
ARG DOTNET_VERSION=5.0.0-preview.5.20230.9

# Installer image
FROM buildpack-deps:buster-curl as installer
ARG DOTNET_VERSION

# Retrieve .NET Core
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-x64.tar.gz \
    && dotnet_sha512='f86f42ef5545eda78aa0884177c7d70c73691dc539dad91c15f1e38741861e6ccbe825dd6f90c53d7525b417471cc085bc98f753e005002efac661cfd79f5142' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -ozxf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET Core runtime image
FROM $REPO:5.0-buster-slim
ARG DOTNET_VERSION

ENV DOTNET_VERSION $DOTNET_VERSION

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
