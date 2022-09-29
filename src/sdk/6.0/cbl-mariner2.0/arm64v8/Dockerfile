ARG REPO=mcr.microsoft.com/dotnet/aspnet
# Installer image
FROM $REPO:6.0.10-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Install .NET SDK
RUN curl -fSL --output dotnet.rpm https://dotnetbuilds.blob.core.windows.net/internal/Sdk/6.0.402-servicing.22476.26/dotnet-sdk-6.0.402-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='a0e2fae3508bd7b746bfa8ebf2c7e458baf2a9dfdb9d3f251af89e6c506bc97094418c4ea9deb71b4fb2ff64fa372970edc40ac3ab42cb84b3b2446c262f7793' \
    && echo "$dotnet_sha512  dotnet.rpm" | sha512sum -c - \
    \
    && curl -fSL --output apphost.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$DOTNET_VERSION/dotnet-apphost-pack-6.0.10-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='97c6acdc138e42e20062e554cec4e627786e124a01a1f67843dfbfca820b1c633568b715af55686df8878bc7e0528318db01ac1b0b0472498d6cc79d6544120d' \
    && echo "$dotnet_sha512  apphost.rpm" | sha512sum -c - \
    \
    && curl -fSL --output targeting-pack.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/6.0.10-servicing.22476.5/dotnet-targeting-pack-6.0.10-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='6bf5b9b3ae34d7d06b4229379e7a7df52cb1473360c613b6c5242386dcb207f59057348dd18e39c54b245cd396c8099fa68681506087745b622335f6ca5c0b65' \
    && echo "$dotnet_sha512  targeting-pack.rpm" | sha512sum -c - \
    \
    && curl -fSL --output aspnetcore-targeting-pack.rpm https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/6.0.10-servicing.22476.17/aspnetcore-targeting-pack-6.0.10-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='0ed8d7bda961e05d638a85cf5f5a5dd62efc9008a43d8cd93f91d9903f0dc24676c89e2745d0aa8eeb038b0fc111da1145d29be5e3fc5cee8dce01601074a34e' \
    && echo "$dotnet_sha512  aspnetcore-targeting-pack.rpm" | sha512sum -c -


# .NET SDK image
FROM $REPO:6.0.10-cbl-mariner2.0-arm64v8

ENV \
    # Unset ASPNETCORE_URLS from aspnet base image
    ASPNETCORE_URLS= \
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
    # Do not show first run text
    DOTNET_NOLOGO=true \
    # SDK version
    DOTNET_SDK_VERSION=6.0.402-servicing.22476.26 \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-CBL-Mariner-2.0-arm64

RUN tdnf install -y \
        git \
        tar \
    && tdnf clean all

COPY --from=installer /dotnet.rpm /dotnet.rpm
COPY --from=installer /apphost.rpm /apphost.rpm
COPY --from=installer /targeting-pack.rpm /targeting-pack.rpm
COPY --from=installer /aspnetcore-targeting-pack.rpm /aspnetcore-targeting-pack.rpm

# Install .NET SDK
RUN tdnf install -y --disablerepo=* dotnet.rpm apphost.rpm targeting-pack.rpm aspnetcore-targeting-pack.rpm \
    && rm dotnet.rpm apphost.rpm targeting-pack.rpm aspnetcore-targeting-pack.rpm \
    # Trigger first run experience by running arbitrary cmd
    && dotnet help

# Install PowerShell global tool
RUN powershell_version=7.2.6 \
    && curl -fSL --output PowerShell.Linux.arm64.$powershell_version.nupkg https://pwshtool.blob.core.windows.net/tool/$powershell_version/PowerShell.Linux.arm64.$powershell_version.nupkg \
    && powershell_sha512='1ba4406e51f428e34c89c7e669ac942f64a11de056b25a04054e4955833bae862ea5f5c1993183c081f1e80a2cdc0d6a48e282a01a0c9dbe47dba97b64d7e919' \
    && echo "$powershell_sha512  PowerShell.Linux.arm64.$powershell_version.nupkg" | sha512sum -c - \
    && mkdir -p /usr/share/powershell \
    && dotnet tool install --add-source / --tool-path /usr/share/powershell --version $powershell_version PowerShell.Linux.arm64 \
    && dotnet nuget locals all --clear \
    && rm PowerShell.Linux.arm64.$powershell_version.nupkg \
    && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
    && chmod 755 /usr/share/powershell/pwsh \
    # To reduce image size, remove the copy nupkg that nuget keeps.
    && find /usr/share/powershell -print | grep -i '.*[.]nupkg$' | xargs rm
