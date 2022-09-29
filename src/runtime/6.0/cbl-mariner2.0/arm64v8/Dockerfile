ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.10-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.10-servicing.22476.5 \
    && curl -fSL --output dotnet-host.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-host-6.0.10-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='1f23ec3103a9ece4dea932f4cb0fa0d5591b3e1daad401fe5f113c1a1f4c0c04a63adbbb75a34c014c34708421d75c4f803de088c2504c20ef1bcc855071d541' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-hostfxr-6.0.10-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='0136f4f9fadf6c18d775ff340e8b0cb2b26e4a1ab3b2ae523bc89f8d271e47579b607be8ec7b79530c7d9a816f9488a5f26e4bf2fd5346c065c82f902a46f86a' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.10-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='49c0b71054437cec5fe9feed87a8710f766dea1def03e33fa4d0c96998427b06cdf6164125c2ad1a3b09999da4b89fdbac496ea1e91490923a1270c56f97c043' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:6.0.10-cbl-mariner2.0-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=6.0.10-servicing.22476.5

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN tdnf install -y --disablerepo=* dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
