ARG REPO=mcr.microsoft.com/dotnet/aspnet
# Installer image
FROM $REPO:7.0.0-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Install .NET SDK
RUN curl -fSL --output dotnet.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/Sdk/7.0.100-rtm.22520.10/dotnet-sdk-7.0.100-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='70a5d5607ba3c7dcfe5da75aa8b6d5fd30ccac8dde917ca12b2317f206f709f93aaea55f9705cfc6b3c4ff2a7669ea18cb234c4be32fa2fcdfac090cde751346' \
    && echo "$dotnet_sha512  dotnet.rpm" | sha512sum -c - \
    \
    && curl -fSL --output apphost.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/Runtime/$DOTNET_VERSION/dotnet-apphost-pack-7.0.0-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='0576815563c929efff9e07fe7d554e0c0c57cbe971792789f637e8b3f0c9a57a09dbd3919a10dca295c02386bd79f2f879ff30c03d234e4f3da2b1dd660cc42a' \
    && echo "$dotnet_sha512  apphost.rpm" | sha512sum -c - \
    \
    && curl -fSL --output targeting-pack.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/Runtime/7.0.0-rtm.22518.5/dotnet-targeting-pack-7.0.0-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='bce00ae590bcea188ed289d68c08bcc68937c350b66bf36fe53918eddd3bfe9e14c9b581dda063e84d4bcd2d09f87133d35ac299f84623924f0cadcced0b851d' \
    && echo "$dotnet_sha512  targeting-pack.rpm" | sha512sum -c - \
    \
    && curl -fSL --output aspnetcore-targeting-pack.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/aspnetcore/Runtime/7.0.0-rtm.22518.19/aspnetcore-targeting-pack-7.0.0-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='3a4648bee90403b7a52b94cd86daac4a0e732a9146dada6f8ac45ed186da890cb78afcb4e05670e8164c685c1628a35f570e14bfb0c79090d58386c58193d6d1' \
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
    DOTNET_SDK_VERSION=7.0.100-rtm.22520.10 \
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
