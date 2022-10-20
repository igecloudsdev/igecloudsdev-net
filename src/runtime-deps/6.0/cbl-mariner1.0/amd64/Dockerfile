# Installer image
FROM mcr.microsoft.com/cbl-mariner/base/core:1.0 AS installer

ARG SAS_QUERY_STRING

RUN dotnet_version=6.0.11-servicing.22518.9 \
    && curl -fSL --output dotnet-runtime-deps.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/Runtime/$dotnet_version/dotnet-runtime-deps-6.0.11-cm.1-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='29eeb9135e547534257c0d0093a101d41356c3de1cf99741bdeb803d59b2101b1821b2557635d4f0c6891ab418157e5e6589799a770f4024ea663616ab7424bb' \
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
