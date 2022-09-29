ARG REPO=mcr.microsoft.com/dotnet/aspnet
# Installer image
FROM $REPO:6.0.10-alpine3.16-arm32v7 AS installer

ARG SAS_QUERY_STRING

# Install .NET SDK
RUN wget -O dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Sdk/6.0.402-servicing.22476.26/dotnet-sdk-6.0.402-linux-musl-arm.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='8301b4bab44aa0f0f16ee69f0ede5ac56bd1ecf802d1fc30b12bd0da48050b40c994ac3fd4ef3fb11ab0ac4803f71301bae6a9f5f3340cbd6d2af1cb01f8c0c4' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -oxzf dotnet.tar.gz -C /usr/share/dotnet ./packs ./sdk ./sdk-manifests ./templates ./LICENSE.txt ./ThirdPartyNotices.txt \
    && rm dotnet.tar.gz


# .NET SDK image
FROM $REPO:6.0.10-alpine3.16-arm32v7

ENV \
    # Unset ASPNETCORE_URLS from aspnet base image
    ASPNETCORE_URLS= \
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
    # Do not show first run text
    DOTNET_NOLOGO=true \
    # SDK version
    DOTNET_SDK_VERSION=6.0.402-servicing.22476.26 \
    # Disable the invariant mode (set in base image)
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Alpine-3.16-arm32

RUN apk add --no-cache \
        curl \
        icu-data-full \
        icu-libs \
        git

COPY --from=installer ["/usr/share/dotnet", "/usr/share/dotnet"]

# Trigger first run experience by running arbitrary cmd
RUN dotnet help
