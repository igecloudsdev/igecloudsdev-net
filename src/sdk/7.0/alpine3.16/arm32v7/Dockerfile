ARG REPO=mcr.microsoft.com/dotnet/aspnet
# Installer image
FROM $REPO:7.0.0-alpine3.16-arm32v7 AS installer

ARG SAS_QUERY_STRING

# Install .NET SDK
RUN wget -O dotnet.tar.gz https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Sdk/7.0.100-rtm.22519.28/dotnet-sdk-7.0.100-linux-musl-arm.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='572ff0618dcf547e5354449ecb660e1510be9d3e123121bcc5786805b70a836bdc07602c2bfc2c666e60d66433144adf51bd413df2a2b7277f1e139689b83b66' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -oxzf dotnet.tar.gz -C /usr/share/dotnet ./packs ./sdk ./sdk-manifests ./templates ./LICENSE.txt ./ThirdPartyNotices.txt \
    && rm dotnet.tar.gz


# .NET SDK image
FROM $REPO:7.0.0-alpine3.16-arm32v7

ENV \
    # Unset ASPNETCORE_URLS from aspnet base image
    ASPNETCORE_URLS= \
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
    # Do not show first run text
    DOTNET_NOLOGO=true \
    # SDK version
    DOTNET_SDK_VERSION=7.0.100-rtm.22519.28 \
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
