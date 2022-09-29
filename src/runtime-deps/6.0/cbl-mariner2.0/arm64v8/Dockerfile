# Installer image
FROM mcr.microsoft.com/cbl-mariner/base/core:2.0 AS installer

ARG SAS_QUERY_STRING

RUN dotnet_version=6.0.10-servicing.22476.5 \
    && curl -fSL --output dotnet-runtime-deps.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-deps-6.0.10-cm.2-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='1ca8462b66d146399a80f9234dd3a2a9b5821fee9468f334abc27e1e6652bc7bb3b17fcb12a4c0a7b852eefaea32e86190ec367c569838cbd19b6ba42bea2cb5' \
    && echo "$dotnet_sha512  dotnet-runtime-deps.rpm" | sha512sum -c -
FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

RUN tdnf install -y \
        ca-certificates-microsoft \
        \
        # .NET dependencies
        glibc \
        icu \
        krb5 \
        libgcc \
        libstdc++ \
        openssl-libs \
        zlib \
    && tdnf clean all

COPY --from=installer /dotnet-runtime-deps.rpm /dotnet-runtime-deps.rpm

# Install dotnet-runtime-deps package
RUN tdnf install -y --disablerepo=* dotnet-runtime-deps.rpm \
    && rm dotnet-runtime-deps.rpm

ENV \
    # Configure web servers to bind to port 80 when present
    ASPNETCORE_URLS=http://+:80 \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true
