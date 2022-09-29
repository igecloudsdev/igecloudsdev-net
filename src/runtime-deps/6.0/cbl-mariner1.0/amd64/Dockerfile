# Installer image
FROM mcr.microsoft.com/cbl-mariner/base/core:1.0 AS installer

ARG SAS_QUERY_STRING

RUN dotnet_version=6.0.10-servicing.22476.5 \
    && curl -fSL --output dotnet-runtime-deps.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-deps-6.0.10-cm.1-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='19429ed1ff1611c33a55f6a71abb0a0ae35c17330ba95c28fb54330b27f04e71bbba2652b63bb6db2ee5d03294b67eb954c2337a435b5e3ad90d7923da6e59b8' \
    && echo "$dotnet_sha512  dotnet-runtime-deps.rpm" | sha512sum -c -
FROM mcr.microsoft.com/cbl-mariner/base/core:1.0

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
RUN rpm --install dotnet-runtime-deps.rpm \
    && rm dotnet-runtime-deps.rpm

ENV \
    # Configure web servers to bind to port 80 when present
    ASPNETCORE_URLS=http://+:80 \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true
