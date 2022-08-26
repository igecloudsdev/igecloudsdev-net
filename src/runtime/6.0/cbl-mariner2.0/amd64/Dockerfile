ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.9-cbl-mariner2.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.9-servicing.22419.5 \
    && curl -fSL --output dotnet-host.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-host-6.0.9-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='4f747ea5b57e8f725767ef2936bfe21d5887b8edf9abbe476637862951f21517e3d8f93a435fbfffa90e9de0fdb7ad023200ddb0b1d1d8eab7274fba0c6a6b0c' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-hostfxr-6.0.9-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='02604db07d0d628aad067f33b23e584aa86fc67f3e019bf1d8f9c9fbf06e4ad6c28f3be12f2771eeb4a510fc81b327bed5b7d319a4ed500d3658c38f48e5d517' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.9-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='0f5afbc038261813f6280c9ef0757aa1f0515fab8d879348417a741fb842f23f91cf5f499de0d5f068b2631b1839d6813b26d893e92c2dca8b7250fd987b3460' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:6.0.9-cbl-mariner2.0-amd64

# .NET Runtime version
ENV DOTNET_VERSION=6.0.9-servicing.22419.5

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN tdnf install -y --disablerepo=* dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
