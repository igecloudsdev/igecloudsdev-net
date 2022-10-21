ARG REPO=mcr.microsoft.com/dotnet/aspnet
# Installer image
FROM $REPO:6.0.11-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Install .NET SDK
RUN curl -fSL --output dotnet.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/Sdk/6.0.403-servicing.22519.42/dotnet-sdk-6.0.403-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='c9e23eb5783577167d6bc6628ce46df8264f0d8d51c394067b82952565513279d50711037442e55f39a19b0c41bce8c81f64c542fe23a5314f10dbce883a4d74' \
    && echo "$dotnet_sha512  dotnet.rpm" | sha512sum -c - \
    \
    && curl -fSL --output apphost.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/Runtime/$DOTNET_VERSION/dotnet-apphost-pack-6.0.11-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='1e9ef8570f48e6e64b149f31ae09ed9dd2bd184bc5cf9e404d203880e17371ab9dafb6b7f69c4d45368ae02e5932447aef3e624eb0de4e65768a6c79e6ff3291' \
    && echo "$dotnet_sha512  apphost.rpm" | sha512sum -c - \
    \
    && curl -fSL --output targeting-pack.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/Runtime/6.0.11-servicing.22518.9/dotnet-targeting-pack-6.0.11-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='91f4f4bc50c512488c4c0b4aa7ed257fdab54ccac8981873d05d50bfc4b519641a90843cc4e0cbb739e2642bfb96047f0f2a2aefc4bbcb39f2549e2ab7f32947' \
    && echo "$dotnet_sha512  targeting-pack.rpm" | sha512sum -c - \
    \
    && curl -fSL --output aspnetcore-targeting-pack.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/aspnetcore/Runtime/6.0.11-servicing.22518.17/aspnetcore-targeting-pack-6.0.11-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='3e32439919205e20f80d21eafde6335cb81fe87d9b303c05314780d1bcbc762f30550cfb8b139a908d08cfb501e489283a94f1b60f3e1a69ffa9cd5f7d24b6ac' \
    && echo "$dotnet_sha512  aspnetcore-targeting-pack.rpm" | sha512sum -c -


# .NET SDK image
FROM $REPO:6.0.11-cbl-mariner2.0-arm64v8

ENV \
    # Unset ASPNETCORE_URLS from aspnet base image
    ASPNETCORE_URLS= \
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
    # Do not show first run text
    DOTNET_NOLOGO=true \
    # SDK version
    DOTNET_SDK_VERSION=6.0.403-servicing.22519.42 \
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
RUN powershell_version=7.2.7 \
    && curl -fSL --output PowerShell.Linux.arm64.$powershell_version.nupkg https://pwshtool.blob.core.windows.net/tool/$powershell_version/PowerShell.Linux.arm64.$powershell_version.nupkg \
    && powershell_sha512='8964490574c5265c6533a6da541ddd309e3fa80a59774c2ea27fde9b3d7ca6e17feee04266906788a4a69db4ac690ee1bb3c44abb16e1e966c4f47c6c71168a8' \
    && echo "$powershell_sha512  PowerShell.Linux.arm64.$powershell_version.nupkg" | sha512sum -c - \
    && mkdir -p /usr/share/powershell \
    && dotnet tool install --add-source / --tool-path /usr/share/powershell --version $powershell_version PowerShell.Linux.arm64 \
    && dotnet nuget locals all --clear \
    && rm PowerShell.Linux.arm64.$powershell_version.nupkg \
    && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
    && chmod 755 /usr/share/powershell/pwsh \
    # To reduce image size, remove the copy nupkg that nuget keeps.
    && find /usr/share/powershell -print | grep -i '.*[.]nupkg$' | xargs rm
