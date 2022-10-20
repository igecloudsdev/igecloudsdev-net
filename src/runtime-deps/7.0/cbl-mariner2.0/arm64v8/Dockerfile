# Installer image
FROM mcr.microsoft.com/cbl-mariner/base/core:2.0 AS installer

ARG SAS_QUERY_STRING

RUN dotnet_version=7.0.0-rtm.22518.5 \
    && curl -fSL --output dotnet-runtime-deps.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Runtime/$dotnet_version/dotnet-runtime-deps-7.0.0-cm.2-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='d02fd1e1bbb7f3ec80bd780fe833a79ffa2a1da1909236f1345259577d741490ba95d83f3d88aea35cf48e577b98d3c762f6208f93de18c825ea88b5d07da202' \
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
