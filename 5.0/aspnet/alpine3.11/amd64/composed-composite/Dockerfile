# TODO: define a shared base stage (build infra doesn't support)
ARG REPO=mcr.microsoft.com/dotnet/core/runtime
ARG ASPNET_VERSION=5.0.0-preview.5.20228.19
ARG DOTNET_VERSION=5.0.0-preview.5.20278.1

# Installer image
FROM $REPO:5.0-alpine3.11-composite as installer
ARG ASPNET_VERSION
# TODO:  This shouldn't be needed because it gets inheritted from the base image, but the update-dependency tool doesn't know that.
ARG DOTNET_VERSION

# Install crossgen2
RUN wget -O crossgen2.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-crossgen2-$DOTNET_VERSION-linux-musl-x64.tar.gz \
    && crossgen2_sha512='40fd2f6df13ffd8fb39b546160a1a6b8f96003259ee644395bcbf95adcae70166acfe86407ee7f5c031381b90a84e69aee343c43c317b9323127853354601652' \
    && echo "$crossgen2_sha512  crossgen2.tar.gz" | sha512sum -c - \
    && mkdir /crossgen2 \
    && tar -C /crossgen2 -oxzf crossgen2.tar.gz \
    && rm crossgen2.tar.gz

RUN \
    # Retrieve ASP.NET
    wget -O aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$ASPNET_VERSION/aspnetcore-runtime-$ASPNET_VERSION-linux-musl-x64.tar.gz \
    && aspnetcore_sha512='1c82a9d03de1ba11878c5ff812cb19c8b5ad9b7270d905f3e3b8be8237eb4cfb2a5fea89d65c60f76ca62f36f04a8d84746dfee955ab80c223e6007d0ca9b608' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -ozxf aspnetcore.tar.gz -C /usr/share/dotnet ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz \
    \
    # Crossgen .NET Core
    && dotnet /crossgen2/crossgen2.dll \
        --composite --inputbubble -O --Os \
        -r /usr/share/dotnet/shared/Microsoft.NETCore.App/$DOTNET_VERSION/*.dll \
        -o /usr/share/dotnet/shared/Microsoft.AspNetCore.App/$ASPNET_VERSION/Microsoft.AspNetCore.App.SharedFramework.dll \
        /usr/share/dotnet/shared/Microsoft.AspNetCore.App/$ASPNET_VERSION/*.dll


# ASP.NET Core image
FROM $REPO:5.0-alpine3.11-composite
ARG ASPNET_VERSION

ENV ASPNET_VERSION $ASPNET_VERSION

COPY --from=installer ["/usr/share/dotnet/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
