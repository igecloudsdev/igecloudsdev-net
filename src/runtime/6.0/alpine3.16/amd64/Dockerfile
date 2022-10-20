ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.11-alpine3.16-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.11-servicing.22518.9 \
    && wget -O dotnet.tar.gz https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/Runtime/$dotnet_version/dotnet-runtime-6.0.11-linux-musl-x64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='306b97c72eb5e0e2596eae00c49ce2650c8d0072d64b39cb16abf7302f76cc21a2a0992a19583e06589c7721fc714f4da9811f2a28ddc3751b84c465cda642f5' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.11-alpine3.16-amd64

# .NET Runtime version
ENV DOTNET_VERSION=6.0.11-servicing.22518.9

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
