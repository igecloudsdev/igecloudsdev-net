ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-rc.1-cbl-mariner2.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rc.1.22426.10 \
    && curl -fSL --output dotnet-host.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-host-$dotnet_version-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='34576882a2409418cbfcfa4c312c1eec8853361f74cd7877322107079d7b6b148dcac8a454289d55b0a606727712f29083fa7c9d05bd8a913041d597a836eedb' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-hostfxr-$dotnet_version-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='61f9e4f18350a5e89d5b90b6be21907c3e59926e9410033e64ee789be7c11c0b8a7b7a0d7e77ac34fcc3a17ec5161b745a13cfb0b9a37088fcaeb7e2db553adb' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-$dotnet_version-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='58a2689b235f14f18ef104896efcbfb2e52ff08662e6cdf52ab820a44698faea5caf1370fd3b546c783d187c58d3ff49fa010bddfd80b7db14f60f60f11df4d3' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:7.0.0-rc.1-cbl-mariner2.0-amd64

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rc.1.22426.10

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN tdnf install -y --disablerepo=* dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
