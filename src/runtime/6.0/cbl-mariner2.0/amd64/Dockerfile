ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.10-cbl-mariner2.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.10-servicing.22469.10 \
    && curl -fSL --output dotnet-host.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-host-6.0.10-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='0fc89e3f46b898855772056f3c99a7ffc96393306eba6295ea0db85851de06d02428a5ab23af3205787d0901c56086d5608614feb1f6e8612559b3924214c435' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-hostfxr-6.0.10-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='69a81bc89bf2110c344dd83dfe94e6225a3a585003495c046e26c7a56609341c4f5cdda996a1311bd87292b917f961dc2807e28e1be6a2ac639dcb310b8be51e' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.10-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='04e28991f9ce624feba813420e17045ee4bb6165fb2b961c6cbba028028a71592bf4c75f58c22d9622861052d2b29bb5440ab823bab7a4e94306ae6784d6b274' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:6.0.10-cbl-mariner2.0-amd64

# .NET Runtime version
ENV DOTNET_VERSION=6.0.10-servicing.22469.10

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN tdnf install -y --disablerepo=* dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
