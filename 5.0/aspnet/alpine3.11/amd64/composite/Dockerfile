# TODO: define a shared base stage (build infra doesn't support)
ARG REPO=mcr.microsoft.com/dotnet/core/runtime-deps
ARG ASPNET_VERSION=5.0.0-preview.5.20279.2
ARG DOTNET_VERSION=5.0.0-preview.5.20278.1


# Installer image
FROM $REPO:5.0-alpine3.11 as installer
ARG ASPNET_VERSION
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
    # TODO:  This is not necessary in final version but because of coherency issues it is need in development.
    wget -O dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-musl-x64.tar.gz \
    && dotnet_sha512='4e1b8147d82045fb58812a90ae9e70810646dde335844be390ac6adb839f1219fd19811d63e345881532a0d27af91e633cc462218ca7a34d429a3731f7b5a686' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir /dotnet \
    && tar -C /dotnet -oxzf dotnet.tar.gz \
    && rm dotnet.tar.gz \
    \
    # Retrieve ASP.NET
    && wget -O aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$ASPNET_VERSION/aspnetcore-runtime-$ASPNET_VERSION-linux-musl-x64.tar.gz \
    && aspnetcore_sha512='6377ac079540d502902b4ff621638400411f3411839cf711ac49c0f9be63c9eb408febea6e01ef9a81d2c4700263e5d5e57752226f3be0e7980894e9211e2ec3' \
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
    # TODO:  It is odd that this assembly contains both the .NET and ASP.NET runtimes yet it is copied to Microsoft.NETCore.App
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
