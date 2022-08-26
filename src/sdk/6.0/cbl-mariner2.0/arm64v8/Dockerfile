ARG REPO=mcr.microsoft.com/dotnet/aspnet
# Installer image
FROM $REPO:6.0.9-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Install .NET SDK
RUN curl -fSL --output dotnet.rpm https://dotnetbuilds.blob.core.windows.net/internal/Sdk/6.0.401-servicing.22421.13/dotnet-sdk-6.0.401-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='e630dcb69e1e7825c528c1b0a21c724c746f30b9ff01bcd0a98ebd65181af7d5e6be5ae4cf7a1edd17e3961bc4f05d5268c5f6e70f44084a88cc75fa1bbe9afb' \
    && echo "$dotnet_sha512  dotnet.rpm" | sha512sum -c - \
    \
    && curl -fSL --output apphost.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$DOTNET_VERSION/dotnet-apphost-pack-6.0.9-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='c4bef7d7213b610aea3fb428072a7978d759f1516cb9b8152f4d07ffe7b260fd34feb4423028efd7bbaced31ab046d9dc9aaf66df32b99a88df50789de1b4557' \
    && echo "$dotnet_sha512  apphost.rpm" | sha512sum -c - \
    \
    && curl -fSL --output targeting-pack.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/6.0.9-servicing.22419.5/dotnet-targeting-pack-6.0.9-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='0fddd5ff95ef3add5460d4e1ddc4ea8117c25427c41a32d374f78b0c557b51bec19b5f5d59c43a80de34e8906a35cae00de07a5d63b16c448aa3700dc61211a6' \
    && echo "$dotnet_sha512  targeting-pack.rpm" | sha512sum -c - \
    \
    && curl -fSL --output aspnetcore-targeting-pack.rpm https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/6.0.9-servicing.22419.26/aspnetcore-targeting-pack-6.0.9-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='00326f0daf28d16013e9bb9250d90ed5bcf017811d2032d9d1c5926f2e2bf8042892d3469d41c8f6bf3fb56c03b8cc71036ce422c6ed6ae69b547d5a845fa480' \
    && echo "$dotnet_sha512  aspnetcore-targeting-pack.rpm" | sha512sum -c -


# .NET SDK image
FROM $REPO:6.0.9-cbl-mariner2.0-arm64v8

ENV \
    # Unset ASPNETCORE_URLS from aspnet base image
    ASPNETCORE_URLS= \
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
    # Do not show first run text
    DOTNET_NOLOGO=true \
    # SDK version
    DOTNET_SDK_VERSION=6.0.401-servicing.22421.13 \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-CBL-Mariner-2.0-arm64

RUN tdnf install -y \
        git \
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
