ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.9-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.9-servicing.22419.5 \
    && curl -fSL --output dotnet-host.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-host-6.0.9-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='9d630a8928b03fa7c140d2104a4e30427b1cdb8552b5bf898aebb9811a0c067244fee47ddb9945e9bdaf31d75a1eda7dc9f81a1d7d37e2be7bf838d919965ef8' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-hostfxr-6.0.9-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='56a344586d6cd9d9099da2af7436d716ad173267de024ec9c35fb60f093400a593cb4b5e4c1d7e06998f1a4a8e93b261a8a2b9c18e77e77e6747e657c670b642' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.9-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='1ad92bd7eee6a9f51650b0be05cd2715845b04c3d42daf0d9c487a840238462343205345b106b257889f4b5f9b0eb0b368987e01d91d752bad9f1b6073b9e63d' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:6.0.9-cbl-mariner2.0-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=6.0.9-servicing.22419.5

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN tdnf install -y --disablerepo=* dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
