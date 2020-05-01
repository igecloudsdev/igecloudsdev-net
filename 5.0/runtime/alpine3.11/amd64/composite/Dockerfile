# TODO: define a shared base stage (build infra doesn't support)
ARG REPO=mcr.microsoft.com/dotnet/core/runtime-deps


# Installer image
FROM $REPO:5.0-alpine3.11 as installer

ENV DOTNET_VERSION 5.0.0-preview.5.20230.9

# Install crossgen2
RUN wget -O crossgen2.tar.gz https://dotnetbinaries.blob.core.windows.net/dockerassets/microsoft.netcore.app.crossgen2.linux-musl-x64.$DOTNET_VERSION.tar.gz \
    && crossgen2_sha512='6beecdd14e52d48b8e794b73dab4b148a50744c1a50f1108c1c30bc1df20fb2cd1741359e7a3f3803e8576ef166308b0d558a18ea6456b343586056025b63e1c' \
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
    && /crossgen2/crossgen2 \
        --composite --inputbubble -O --Os \
        -o /dotnet/shared/Microsoft.NETCore.App/$DOTNET_VERSION/Microsoft.NETCore.App.SharedFramework.dll \
        /dotnet/shared/Microsoft.NETCore.App/$DOTNET_VERSION/*.dll


# .NET runtime image
FROM $REPO:5.0-alpine3.11

ENV DOTNET_VERSION 5.0.0-preview.5.20230.9

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]
RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
