ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-rc.2-cbl-mariner2.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rc.2.22472.3 \
    && curl -fSL --output dotnet-host.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-host-$dotnet_version-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='8f864f53a12b6634b88a3212c6893c8e6b00ea97ef694240e66182f68434c5897e484b8300d05dd17c510de532d41fdc0ef564230f0a443eca2cd3d2d8485cf1' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-hostfxr-$dotnet_version-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='6751d25d2da9de82b84979e98c728ab2a5fc1a53125a354f26b7c09135c3213db0a2b7d7ab82d16144e87658b0a550995a7f192eed56f851fb77269c302aee6f' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-$dotnet_version-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='e9a47bad53d69b82015d9f1ecbe54e12e75a0fe9c23c1eefc6b29033c390bba5045199a7fa80552708eaaf97f5a885ba11ee8f41931de9ae2e091dae37bdb715' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:7.0.0-rc.2-cbl-mariner2.0-amd64

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rc.2.22472.3

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN tdnf install -y --disablerepo=* dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
