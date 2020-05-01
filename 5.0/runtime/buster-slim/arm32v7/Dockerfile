ARG REPO=mcr.microsoft.com/dotnet/core/runtime-deps
ARG DOTNET_VERSION=5.0.0-preview.5.20230.9

# Installer image
FROM arm32v7/buildpack-deps:buster-curl as installer
ARG DOTNET_VERSION

# Retrieve .NET Core
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-arm.tar.gz \
    && dotnet_sha512='9775de2b011d45b1d9b5f9929f16d2c30622eb7dd56979757ca9f4c90a2a588e80142fe4de60e1e9a49530070e823a6492bc4e02cc950fcbc058c682c4799ef8' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -ozxf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET Core runtime image
FROM $REPO:5.0-buster-slim-arm32v7
ARG DOTNET_VERSION

ENV DOTNET_VERSION $DOTNET_VERSION

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
