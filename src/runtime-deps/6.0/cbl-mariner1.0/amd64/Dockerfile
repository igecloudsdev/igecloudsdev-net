# Installer image
FROM mcr.microsoft.com/cbl-mariner/base/core:1.0 AS installer

ARG SAS_QUERY_STRING

RUN dotnet_version=6.0.10-servicing.22469.10 \
    && curl -fSL --output dotnet-runtime-deps.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-deps-6.0.10-cm.1-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='67e8a53e9700d4b7769c6ef383cc9bf2754821ea4498a5e1dce15d65a56ac4c3c3779cee676fe916d46108ca8d9bc25494face74d7f28c5919a6d0d62e790ce0' \
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
