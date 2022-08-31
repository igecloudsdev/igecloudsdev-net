ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-rc.1-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rc.1.22426.10 \
    && curl -fSL --output dotnet-host.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-host-$dotnet_version-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='2567acd5243b37de2d21d9d0a26c904552385dcd48336f846fcab7dd54517c54ed8dad672cc2f1eedcaf2a294f4928b3e4c0e07e46b3acf3498d24b9f2c5806f' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-hostfxr-$dotnet_version-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='b77bffe064b0ae49815c66f4730fb3aec4a3ac97591249d6ff66cfc9c57f43875f2b34c7e6247d8a0e7268e2afaede9c4f74b47bf17556e647f45891af737973' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-$dotnet_version-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='9ea7507f1fd12b42e1c8764d26ff3037f41e65456b14f430f82e3dd2e5c168268ba4b1d685fa66acddafe31a3d979c0d904f2cdb2701a4fc9350be3fba8d5ad4' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:7.0.0-rc.1-cbl-mariner2.0-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rc.1.22426.10

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN tdnf install -y --disablerepo=* dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
