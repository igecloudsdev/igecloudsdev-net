ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.10-alpine3.16-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.10-servicing.22476.5 \
    && wget -O dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.10-linux-musl-arm64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='4f00918771c56856231c715ad9f1febcdc39127ac0265c97da76375ba20cbc7109ee696dae72e5f5d8fa1998588e697a4a6785c919e96a7bda7408a500cc59e1' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.10-alpine3.16-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=6.0.10-servicing.22476.5

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
