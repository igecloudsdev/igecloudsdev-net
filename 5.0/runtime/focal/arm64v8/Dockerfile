ARG REPO=mcr.microsoft.com/dotnet/core/runtime-deps
ARG DOTNET_VERSION=5.0.0-preview.5.20230.9

# Installer image
FROM arm64v8/buildpack-deps:focal-curl as installer
ARG DOTNET_VERSION

# Retrieve .NET Core
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-arm64.tar.gz \
    && dotnet_sha512='a0be56c72c22a7f03a4d68e4a8cbe538735372b084b705cc63df4b02648e1e31f4fc82d115c4c78a50eb3269307bd09cf16b4fa4e54f9f826fc0d1a21e67a1f3' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -ozxf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET Core runtime image
FROM $REPO:5.0-focal-arm64v8
ARG DOTNET_VERSION

ENV DOTNET_VERSION $DOTNET_VERSION

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
