# TODO: Potentially define a shared crossgen2 base stage for build optimization (build infra doesn't support)
ARG REPO=mcr.microsoft.com/dotnet/core/runtime-deps
ARG DOTNET_VERSION=5.0.0-preview.5.20278.1

# Installer image
FROM $REPO:5.0-alpine3.11 as installer
ARG DOTNET_VERSION

# Install crossgen2
RUN wget -O crossgen2.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-crossgen2-$DOTNET_VERSION-linux-musl-x64.tar.gz \
    && crossgen2_sha512='f5d8bfa0eeded2da2065b071b8bfeb718cbb29b4526326c5e9a09cc9b92da1eca0d1b4e1bf85fe297eaeaf6115a17ff76c800cdc6a4fa9125e78b1c42fbf72c1' \
    && echo "$crossgen2_sha512  crossgen2.tar.gz" | sha512sum -c - \
    && mkdir /crossgen2 \
    && tar -C /crossgen2 -oxzf crossgen2.tar.gz \
    && rm crossgen2.tar.gz

RUN \
    # Retrieve .NET
    wget -O dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-musl-x64.tar.gz \
    && dotnet_sha512='4e1b8147d82045fb58812a90ae9e70810646dde335844be390ac6adb839f1219fd19811d63e345881532a0d27af91e633cc462218ca7a34d429a3731f7b5a686' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir /dotnet \
    && tar -C /dotnet -oxzf dotnet.tar.gz \
    && rm dotnet.tar.gz \
    \
    # Crossgen .NET
    && cp -R /dotnet/ /working-dotnet/ \
    && /working-dotnet/dotnet /crossgen2/crossgen2.dll \
        --composite --inputbubble -O --Os \
        -o /dotnet/shared/Microsoft.NETCore.App/$DOTNET_VERSION/Microsoft.NETCore.App.SharedFramework.dll \
        /dotnet/shared/Microsoft.NETCore.App/$DOTNET_VERSION/*.dll \
    && rm -r /working-dotnet


# .NET runtime image
FROM $REPO:5.0-alpine3.11
ARG DOTNET_VERSION

ENV DOTNET_VERSION $DOTNET_VERSION

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]
RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
