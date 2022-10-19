ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rtm.22513.8 \
    && curl -fSL --output dotnet-host.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-host-7.0.0-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='328cd3e8188f679fe7f7100d9cfa441ce7731d8ea923a58c6a93776a033e80362335f5184194dfff0d27a0d090c29ee2019dffb48fee4ebc6bac7d928dbd4503' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-hostfxr-7.0.0-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='f75fbe5bcf490b78b434d7e4b461bc4e98d1cd7df6d8e578f4fd9e9bb34ab474795d6968472dd1fff1d78fa78f652ce54f8d2fdc6f568484a3930a11f01d728d' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-7.0.0-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='2364e08b296c1b66f48ebf645befc9d2102204240e74515c6b5968a06d68e6cca3600825d190f159a87e0075991e7cde423e59204444325df2f373054e22949e' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:7.0.0-cbl-mariner2.0-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rtm.22513.8

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN tdnf install -y --disablerepo=* dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
