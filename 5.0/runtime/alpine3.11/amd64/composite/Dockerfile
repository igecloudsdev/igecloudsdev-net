# TODO: Potentially define a shared crossgen2 base stage for build optimization (build infra doesn't support)
ARG REPO=mcr.microsoft.com/dotnet/core/runtime-deps
ARG DOTNET_VERSION=5.0.0-preview.5.20230.9

# Installer image
FROM $REPO:5.0-alpine3.11 as installer
ARG DOTNET_VERSION

# Install crossgen2
RUN wget -O crossgen2.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-crossgen2-$DOTNET_VERSION-linux-musl-x64.tar.gz \
    && crossgen2_sha512='40fd2f6df13ffd8fb39b546160a1a6b8f96003259ee644395bcbf95adcae70166acfe86407ee7f5c031381b90a84e69aee343c43c317b9323127853354601652' \
    && echo "$crossgen2_sha512  crossgen2.tar.gz" | sha512sum -c - \
    && mkdir /crossgen2 \
    && tar -C /crossgen2 -oxzf crossgen2.tar.gz \
    && rm crossgen2.tar.gz

RUN \
    # Retrieve .NET
    wget -O dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-musl-x64.tar.gz \
    && dotnet_sha512='41621dad0f018b3f48c4777594f2ba83dfd438ce77e8a9de85b20d364d30ef110f64a3d8ddd13763a6b1c7775cf66e34eb40760f115b317b8f44c5080576b1fc' \
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
