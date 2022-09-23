ARG REPO=mcr.microsoft.com/dotnet/aspnet
# Installer image
FROM $REPO:6.0.10-alpine3.16-arm32v7 AS installer

ARG SAS_QUERY_STRING

# Install .NET SDK
RUN wget -O dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Sdk/6.0.402-servicing.22470.36/dotnet-sdk-6.0.402-linux-musl-arm.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='d52a193a1d9bd43f9939842c78605d0a469cbf8ca89735bc59f3cae1ff835131b28d808e83f14677db0151f1bec6b5bd6ff455ea0ef3c5abc3944875a4b6d796' \
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
    DOTNET_SDK_VERSION=6.0.402-servicing.22470.36 \
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
