# Installer image
FROM mcr.microsoft.com/cbl-mariner/base/core:1.0 AS installer

ARG SAS_QUERY_STRING

RUN dotnet_version=6.0.9-servicing.22419.5 \
    && curl -fSL --output dotnet-runtime-deps.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-deps-6.0.9-cm.1-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='885426d3043a9abd3825acd2130572dd5184d112549b1e6b298d91cb441ce89339a23f21918c336a8fbd5b8e05d3e5abb6e0eeb42be62fb8de26ceb02d110f09' \
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
