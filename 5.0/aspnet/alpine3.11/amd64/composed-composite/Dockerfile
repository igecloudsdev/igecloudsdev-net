# TODO: define a shared base stage (build infra doesn't support)
ARG REPO=mcr.microsoft.com/dotnet/core/runtime
ARG ASPNET_VERSION=5.0.0-preview.5.20279.2
ARG DOTNET_VERSION=5.0.0-preview.5.20278.1

# Installer image
FROM $REPO:5.0-alpine3.11-composite as installer
ARG ASPNET_VERSION
# TODO:  This shouldn't be needed because it gets inheritted from the base image, but the update-dependency tool doesn't know that.
ARG DOTNET_VERSION

# Install crossgen2
RUN wget -O crossgen2.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-crossgen2-$DOTNET_VERSION-linux-musl-x64.tar.gz \
    && crossgen2_sha512='f5d8bfa0eeded2da2065b071b8bfeb718cbb29b4526326c5e9a09cc9b92da1eca0d1b4e1bf85fe297eaeaf6115a17ff76c800cdc6a4fa9125e78b1c42fbf72c1' \
    && echo "$crossgen2_sha512  crossgen2.tar.gz" | sha512sum -c - \
    && mkdir /crossgen2 \
    && tar -C /crossgen2 -oxzf crossgen2.tar.gz \
    && rm crossgen2.tar.gz

RUN \
    # Retrieve ASP.NET
    wget -O aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$ASPNET_VERSION/aspnetcore-runtime-$ASPNET_VERSION-linux-musl-x64.tar.gz \
    && aspnetcore_sha512='6377ac079540d502902b4ff621638400411f3411839cf711ac49c0f9be63c9eb408febea6e01ef9a81d2c4700263e5d5e57752226f3be0e7980894e9211e2ec3' \
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
