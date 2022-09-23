ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.10-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.10-servicing.22469.10 \
    && curl -fSL --output dotnet-host.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-host-6.0.10-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='1570384969bbe1aa6a0eb018cc1247b05e62decc9225fd36630abdddee1ce6f39e818b947c134000ab03c887c4ae20cd520d21d382c7dfb04a6bb40d88e74439' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-hostfxr-6.0.10-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='b46cced4c5dd1bc262cc6ba0287893d450c3ee80a0a3962c90eadec0d2c8bd69d7dad88d6d3aebb9a42194a7479aa58207e0f977355e10d74dc9a55246a6d49e' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.10-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='d738daf822abba83938ad7a071db5658539d42711c1ca89cf9845c73c0637d456b9c1aa486f9153245ce1486618af15e59feb45bb3782e114db22cbdee7a15db' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:6.0.10-cbl-mariner2.0-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=6.0.10-servicing.22469.10

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN tdnf install -y --disablerepo=* dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
