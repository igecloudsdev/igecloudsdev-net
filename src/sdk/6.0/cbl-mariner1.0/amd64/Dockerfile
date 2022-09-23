ARG REPO=mcr.microsoft.com/dotnet/aspnet
# Installer image
FROM $REPO:6.0.10-cbl-mariner1.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Install .NET SDK
RUN curl -fSL --output dotnet.rpm https://dotnetbuilds.blob.core.windows.net/internal/Sdk/6.0.402-servicing.22470.36/dotnet-sdk-6.0.402-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='efbd49a28089e6b5caf1c4caf77384e9965166e1b14457c278fde8e1d413d0f4181f8b82c990db08a82073c9243960c66a9dec203c112760baddba80234d7a22' \
    && echo "$dotnet_sha512  dotnet.rpm" | sha512sum -c - \
    \
    && curl -fSL --output apphost.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$DOTNET_VERSION/dotnet-apphost-pack-6.0.10-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='ab85b050f9b5bc05461e62bcbef578c95d4d48b5516cfa05a53e489aad974a52d0442b2ea6f6a4eea6bc3caddad039926740445ea4fbf9d18907741f99592b36' \
    && echo "$dotnet_sha512  apphost.rpm" | sha512sum -c - \
    \
    && curl -fSL --output targeting-pack.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/6.0.10-servicing.22469.10/dotnet-targeting-pack-6.0.10-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='eecd146ea4c951aced309722e7e9359d2228e2f48ccb609b2e8684879281d63d1096c3222fe8a2dcfd0a9339eb7696f11f1b41848e10468baa4b819fae7c8426' \
    && echo "$dotnet_sha512  targeting-pack.rpm" | sha512sum -c - \
    \
    && curl -fSL --output aspnetcore-targeting-pack.rpm https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/6.0.10-servicing.22469.29/aspnetcore-targeting-pack-6.0.10-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='60745a9a9eb7da5b0a08ebae0aca9d341a6032f86850c389e1eff63285718b4d15e4709e67e0a7bfa6ad8c45d5133547929a3b1f3533c0b1533a4d8d89440bfe' \
    && echo "$dotnet_sha512  aspnetcore-targeting-pack.rpm" | sha512sum -c - \
    \
    && curl -fSL --output netstandard-targeting-pack.rpm https://dotnetcli.azureedge.net/dotnet/Runtime/3.1.0/netstandard-targeting-pack-2.1.0-x64.rpm \
    && dotnet_sha512='fab41a86b9182b276992795247868c093890c6b3d5739376374a302430229624944998e054de0ff99bddd9459fc9543636df1ebd5392db069ae953ac17ea2880' \
    && echo "$dotnet_sha512  netstandard-targeting-pack.rpm" | sha512sum -c -


# .NET SDK image
FROM $REPO:6.0.10-cbl-mariner1.0-amd64

ENV \
    # Unset ASPNETCORE_URLS from aspnet base image
    ASPNETCORE_URLS= \
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
    # Do not show first run text
    DOTNET_NOLOGO=true \
    # SDK version
    DOTNET_SDK_VERSION=6.0.402-servicing.22470.36 \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-CBL-Mariner-1.0

RUN tdnf install -y \
        git \
    && tdnf clean all

COPY --from=installer /dotnet.rpm /dotnet.rpm
COPY --from=installer /apphost.rpm /apphost.rpm
COPY --from=installer /targeting-pack.rpm /targeting-pack.rpm
COPY --from=installer /aspnetcore-targeting-pack.rpm /aspnetcore-targeting-pack.rpm
COPY --from=installer /netstandard-targeting-pack.rpm /netstandard-targeting-pack.rpm

# Install .NET SDK
RUN rpm --install dotnet.rpm apphost.rpm targeting-pack.rpm aspnetcore-targeting-pack.rpm netstandard-targeting-pack.rpm \
    && rm dotnet.rpm apphost.rpm targeting-pack.rpm aspnetcore-targeting-pack.rpm netstandard-targeting-pack.rpm \
    # Trigger first run experience by running arbitrary cmd
    && dotnet help

# Install PowerShell global tool
RUN powershell_version=7.2.6 \
    && curl -fSL --output PowerShell.Linux.x64.$powershell_version.nupkg https://pwshtool.blob.core.windows.net/tool/$powershell_version/PowerShell.Linux.x64.$powershell_version.nupkg \
    && powershell_sha512='780514526d536f8249938f1abc801bf34fca7a93e6824cfb4af858d19ef49d5904e97bd7a62e5aac9400189c1964d1a38a3ebe0c16710b17776a8376e5a1e085' \
    && echo "$powershell_sha512  PowerShell.Linux.x64.$powershell_version.nupkg" | sha512sum -c - \
    && mkdir -p /usr/share/powershell \
    && dotnet tool install --add-source / --tool-path /usr/share/powershell --version $powershell_version PowerShell.Linux.x64 \
    && dotnet nuget locals all --clear \
    && rm PowerShell.Linux.x64.$powershell_version.nupkg \
    && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
    && chmod 755 /usr/share/powershell/pwsh \
    # To reduce image size, remove the copy nupkg that nuget keeps.
    && find /usr/share/powershell -print | grep -i '.*[.]nupkg$' | xargs rm
