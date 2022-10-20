ARG REPO=mcr.microsoft.com/dotnet/aspnet
# Installer image
FROM $REPO:7.0.0-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Install .NET SDK
RUN curl -fSL --output dotnet.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Sdk/7.0.100-rtm.22519.28/dotnet-sdk-7.0.100-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='72917cb1f63f192c0ceadc0b663d750a1e318cf6c4e17ab59ee5195b09209816eeaa1ba3e09ca7f0aee4bf795cc3c115643e6b62b0ea64e7b0cf7bdabb988d28' \
    && echo "$dotnet_sha512  dotnet.rpm" | sha512sum -c - \
    \
    && curl -fSL --output apphost.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Runtime/$DOTNET_VERSION/dotnet-apphost-pack-7.0.0-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='975e5fbb6fa18e78cf03e7d0a49ec7525e14375597fb69e8716b2e5017fbce30e8caaa639bf816232998a1ebb8a12af398d11be9f8cf998f11e520e5d7809b6e' \
    && echo "$dotnet_sha512  apphost.rpm" | sha512sum -c - \
    \
    && curl -fSL --output targeting-pack.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Runtime/7.0.0-rtm.22518.5/dotnet-targeting-pack-7.0.0-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='c379f84cc56120a6d6e1ebcd57708f2b982ad8b7e48b56edaffbbb5dd08abba3d43892165b6739fd8dba11e2deb496679dd1ff6f8d2a643cdd93fb367b4a98b7' \
    && echo "$dotnet_sha512  targeting-pack.rpm" | sha512sum -c - \
    \
    && curl -fSL --output aspnetcore-targeting-pack.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/aspnetcore/Runtime/7.0.0-rtm.22518.19/aspnetcore-targeting-pack-7.0.0-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='cac8cdc3fb1b491ab59ff62a1afd458d8bc443b2aa0d63b1a4c2a775ea54b7fedba13b5ee065d4fa42202026dc13881dc2415187b959a24d2159928899a0c82b' \
    && echo "$dotnet_sha512  aspnetcore-targeting-pack.rpm" | sha512sum -c -


# .NET SDK image
FROM $REPO:7.0.0-cbl-mariner2.0-arm64v8

ENV \
    # Unset ASPNETCORE_URLS from aspnet base image
    ASPNETCORE_URLS= \
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
    # Do not show first run text
    DOTNET_NOLOGO=true \
    # SDK version
    DOTNET_SDK_VERSION=7.0.100-rtm.22519.28 \
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
