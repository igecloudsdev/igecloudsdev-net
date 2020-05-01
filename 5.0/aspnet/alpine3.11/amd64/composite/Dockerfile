# TODO: define a shared base stage (build infra doesn't support)
ARG REPO=mcr.microsoft.com/dotnet/core/runtime-deps
ARG ASPNET_VERSION=5.0.0-preview.5.20228.19
ARG DOTNET_VERSION=5.0.0-preview.5.20230.9


# Installer image
FROM $REPO:5.0-alpine3.11 as installer
ARG ASPNET_VERSION
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
    # TODO:  This is not necessary in final version but because of coherency issues it is need in development.
    wget -O dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-musl-x64.tar.gz \
    && dotnet_sha512='41621dad0f018b3f48c4777594f2ba83dfd438ce77e8a9de85b20d364d30ef110f64a3d8ddd13763a6b1c7775cf66e34eb40760f115b317b8f44c5080576b1fc' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir /dotnet \
    && tar -C /dotnet -oxzf dotnet.tar.gz \
    && rm dotnet.tar.gz \
    \
    # Retrieve .NET.NET
    && wget -O aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$ASPNET_VERSION/aspnetcore-runtime-$ASPNET_VERSION-linux-musl-x64.tar.gz \
    && aspnetcore_sha512='1c82a9d03de1ba11878c5ff812cb19c8b5ad9b7270d905f3e3b8be8237eb4cfb2a5fea89d65c60f76ca62f36f04a8d84746dfee955ab80c223e6007d0ca9b608' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -ozxf aspnetcore.tar.gz -C /dotnet ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz \
    \
    # Crossgen .NET Core
    && mkdir -p /work/input \
    && cp /dotnet/shared/Microsoft.NETCore.App/$DOTNET_VERSION/*.dll /work/input \
    && cp /dotnet/shared/Microsoft.AspNetCore.App/$ASPNET_VERSION/*.dll /work/input \
    && mkdir -p /work/output \
    && /dotnet/dotnet /crossgen2/crossgen2.dll \
        --composite --inputbubble -O --Os \
        -o /work/output/SharedFramework.dll \
        /work/input/*.dll \
    && for b in /dotnet/shared/Microsoft.NETCore.App/$DOTNET_VERSION/*.dll; \
        do \
            a=/work/output/`basename ${b}`; \
            test -e ${a} && cp ${a} /dotnet/shared/Microsoft.NETCore.App/$DOTNET_VERSION; \
        done \
    && for b in /dotnet/shared/Microsoft.AspNetCore.App/$ASPNET_VERSION/*.dll; \
        do \
            a=/work/output/`basename ${b}`; \
            test -e ${a} && cp ${a} /dotnet/shared/Microsoft.AspNetCore.App/$ASPNET_VERSION; \
        done \
    # TODO:  It is odd that this assembly contains both the .NET and ASP.NET runtimes and is copied to Microsoft.NETCore.App
    && cp /work/output/SharedFramework.dll /dotnet/shared/Microsoft.NETCore.App/$DOTNET_VERSION \
    && rm -r /work


# ASP.NET image
FROM $REPO:5.0-alpine3.11
ARG ASPNET_VERSION
ARG DOTNET_VERSION

ENV ASPNET_VERSION=$ASPNET_VERSION \
    DOTNET_VERSION=$DOTNET_VERSION

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]
RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
