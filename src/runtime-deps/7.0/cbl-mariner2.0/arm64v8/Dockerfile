# Installer image
FROM mcr.microsoft.com/cbl-mariner/base/core:2.0 AS installer

ARG SAS_QUERY_STRING

RUN dotnet_version=7.0.0-rtm.22518.5 \
    && curl -fSL --output dotnet-runtime-deps.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/Runtime/$dotnet_version/dotnet-runtime-deps-7.0.0-cm.2-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='0c0e53a4beb4bb4aaad671eac89dfdd879c81be9c55c76980f7e7a235e8744c708c2a7284f70db37fce45e2b7b737c5cf4a722b0f97f11f4e23b13871fa39f64' \
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
