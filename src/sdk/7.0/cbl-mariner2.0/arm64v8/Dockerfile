ARG REPO=mcr.microsoft.com/dotnet/aspnet
# Installer image
FROM $REPO:7.0.0-rc.2-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Install .NET SDK
RUN curl -fSL --output dotnet.rpm https://dotnetbuilds.blob.core.windows.net/internal/Sdk/7.0.100-rc.2.22477.23/dotnet-sdk-7.0.100-rc.2.22477.23-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='94014eb7356bb9d7ed8d31f4ee62ff0fa4ea0ba407c6ee6417af02e7eb7fd831a66ae22d4a628fdae7c1b5e7b84b74364686a30c3a4ea58cc404fa88c3fce4d2' \
    && echo "$dotnet_sha512  dotnet.rpm" | sha512sum -c - \
    \
    && curl -fSL --output apphost.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$DOTNET_VERSION/dotnet-apphost-pack-$DOTNET_VERSION-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='2902c6503b404982cd37a3bb703acb4c47094764a99838cd70df0b01aa57a449dc9e2d276c334d7a9b2bde0f5a7a19e2d6628d39b62c1bfd8439233e3e770988' \
    && echo "$dotnet_sha512  apphost.rpm" | sha512sum -c - \
    \
    && curl -fSL --output targeting-pack.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/7.0.0-rc.2.22472.3/dotnet-targeting-pack-7.0.0-rc.2.22472.3-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='97fdd2fcce5fa13dcce46d2c3a141ac884ccf31b6023f044a4621af9b25796874f46a79ad99baf8affdda545e015554a0e7a4b0b01b4b424eb92dc088eaf8966' \
    && echo "$dotnet_sha512  targeting-pack.rpm" | sha512sum -c - \
    \
    && curl -fSL --output aspnetcore-targeting-pack.rpm https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/7.0.0-rc.2.22476.2/aspnetcore-targeting-pack-7.0.0-rc.2.22476.2-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='bacdcd24c3f733f590ed0281337535e3175943ab8bc7d171e8179e29b90cb0cafab7e9c9a7edcd18065ccad988f7eaf99dac653d646bb40d95d11310c8e9d9ed' \
    && echo "$dotnet_sha512  aspnetcore-targeting-pack.rpm" | sha512sum -c -


# .NET SDK image
FROM $REPO:7.0.0-rc.2-cbl-mariner2.0-arm64v8

ENV \
    # Unset ASPNETCORE_URLS from aspnet base image
    ASPNETCORE_URLS= \
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
    # Do not show first run text
    DOTNET_NOLOGO=true \
    # SDK version
    DOTNET_SDK_VERSION=7.0.100-rc.2.22477.23 \
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
RUN powershell_version=7.3.0-preview.8 \
    && curl -fSL --output PowerShell.Linux.arm64.$powershell_version.nupkg https://pwshtool.blob.core.windows.net/tool/$powershell_version/PowerShell.Linux.arm64.$powershell_version.nupkg \
    && powershell_sha512='22a7ddee5e9638f92201b1b3f2f2fba99b4dc8f3ae3864df03dfb6f821cd29586e3603b938b284bbfc0e9fe01553bef024ad6eb0267154a32a675a41151f8285' \
    && echo "$powershell_sha512  PowerShell.Linux.arm64.$powershell_version.nupkg" | sha512sum -c - \
    && mkdir -p /usr/share/powershell \
    && dotnet tool install --add-source / --tool-path /usr/share/powershell --version $powershell_version PowerShell.Linux.arm64 \
    && dotnet nuget locals all --clear \
    && rm PowerShell.Linux.arm64.$powershell_version.nupkg \
    && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
    && chmod 755 /usr/share/powershell/pwsh \
    # To reduce image size, remove the copy nupkg that nuget keeps.
    && find /usr/share/powershell -print | grep -i '.*[.]nupkg$' | xargs rm
