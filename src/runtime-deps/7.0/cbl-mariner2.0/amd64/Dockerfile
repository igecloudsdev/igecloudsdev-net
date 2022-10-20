# Installer image
FROM mcr.microsoft.com/cbl-mariner/base/core:2.0 AS installer

ARG SAS_QUERY_STRING

RUN dotnet_version=7.0.0-rtm.22518.5 \
    && curl -fSL --output dotnet-runtime-deps.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Runtime/$dotnet_version/dotnet-runtime-deps-7.0.0-cm.2-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='7b39f20147ea50286315ddd49c7e8d283dc6cfa25ce0fce1d38f816722bb3451816a9b8fc528698ba5357e22c73cfc91009b728b54ca497f1d17246cdd95e589' \
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
