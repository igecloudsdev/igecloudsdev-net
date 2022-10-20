ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.11-cbl-mariner2.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.11-servicing.22518.9 \
    && curl -fSL --output dotnet-host.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/Runtime/$dotnet_version/dotnet-host-6.0.11-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='ab202c1ab35cc2ae9c197f746ca095a7003a274c4af7cc4efb0934507b4c45289c865493d5c29331f490f843f4c688f9802fa53bedb8f4dfa9250e066daa1d1e' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/Runtime/$dotnet_version/dotnet-hostfxr-6.0.11-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='6487b88c4e1e3752c1e2486e3efc7c176ebe72f396a908b5516fbeb777e245ca36ee1cb0e764edeed7aee9cb5b8fef519be6b53197b9f5927e9459d30fb0dd74' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/Runtime/$dotnet_version/dotnet-runtime-6.0.11-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='592bd8390779bf899a3a101d46bbb96833b2683f204a3deb10fa054ab3e76dd15a78094802f8da2e761bdc164c35c688e65f05c91bdab532c899540fcf197586' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:6.0.11-cbl-mariner2.0-amd64

# .NET Runtime version
ENV DOTNET_VERSION=6.0.11-servicing.22518.9

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN tdnf install -y --disablerepo=* dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
