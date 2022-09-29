ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.10-cbl-mariner1.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.10-servicing.22476.5 \
    && curl -fSL --output dotnet-host.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-host-6.0.10-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='d290bfdc6aba732c021dd9e444964388e9f6c30e449f7738d947d30eac32de9b79171319897e87735a26f8afdac6ea158876e2634a842aac9e7e19c21f5193a1' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-hostfxr-6.0.10-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='a898fdde576329306d47c8b414750ac4f3ab66513eb5e300bcaa83e9b69a510e379c21bef5f2f566c70111e0bbffd99d9c337eb742aed0c3ee920a2908edc99c' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.10-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='b684da43ef9af5aa1be97fdd1293b3f9212c7c186b6e54063e90f44ef098d4701b2c3a218879852cc75129db3ebe2035289a9e44225ab03bd285e163a2fb72bf' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:6.0.10-cbl-mariner1.0-amd64

# .NET Runtime version
ENV DOTNET_VERSION=6.0.10-servicing.22476.5

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN rpm --install dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
