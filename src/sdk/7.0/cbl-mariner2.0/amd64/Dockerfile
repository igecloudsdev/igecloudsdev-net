ARG REPO=mcr.microsoft.com/dotnet/aspnet
# Installer image
FROM $REPO:7.0.0-cbl-mariner2.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Install .NET SDK
RUN curl -fSL --output dotnet.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/Sdk/7.0.100-rtm.22520.10/dotnet-sdk-7.0.100-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='366b00925e41ec34b1fef78be5d4887ef24ad9ca3a926246d5ed1440bf568e92c3579f9a5ff7a32fd2b805436729d1a28d00726f7b333073f6a623fd62de0efa' \
    && echo "$dotnet_sha512  dotnet.rpm" | sha512sum -c - \
    \
    && curl -fSL --output apphost.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/Runtime/$DOTNET_VERSION/dotnet-apphost-pack-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='7326f5473645218625c6ab2aea64f946abeefad6f08d1218d4bfa5d02d9e9bb3b43a8d2ff38ce6d2d6e83562309518edb5df0578251f681d98e7e9a388d71993' \
    && echo "$dotnet_sha512  apphost.rpm" | sha512sum -c - \
    \
    && curl -fSL --output targeting-pack.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/Runtime/7.0.0-rtm.22518.5/dotnet-targeting-pack-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='6133931665b3ed7fde7d35695b80e6829e0f55de60416cb87cdfa4ad9ec4f1f687991067abf0a75f3d02207264ee457761fdb9a41a97e2704ef2a33d3be44038' \
    && echo "$dotnet_sha512  targeting-pack.rpm" | sha512sum -c - \
    \
    && curl -fSL --output aspnetcore-targeting-pack.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/aspnetcore/Runtime/7.0.0-rtm.22518.19/aspnetcore-targeting-pack-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='5256c125aaab3bc5367c873819cadbea3d193448d1d006877d5e6bdc78b7c0e72c175c677037154360a32edeb11b5ec2d0f27aed23c6eba7a27580c74e06c7ff' \
    && echo "$dotnet_sha512  aspnetcore-targeting-pack.rpm" | sha512sum -c - \
    \
    && curl -fSL --output netstandard-targeting-pack.rpm https://dotnetcli.azureedge.net/dotnet/Runtime/3.1.0/netstandard-targeting-pack-2.1.0-x64.rpm \
    && dotnet_sha512='fab41a86b9182b276992795247868c093890c6b3d5739376374a302430229624944998e054de0ff99bddd9459fc9543636df1ebd5392db069ae953ac17ea2880' \
    && echo "$dotnet_sha512  netstandard-targeting-pack.rpm" | sha512sum -c -


# .NET SDK image
FROM $REPO:7.0.0-cbl-mariner2.0-amd64

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
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-CBL-Mariner-2.0

RUN tdnf install -y \
        git \
        tar \
    && tdnf clean all

COPY --from=installer /dotnet.rpm /dotnet.rpm
COPY --from=installer /apphost.rpm /apphost.rpm
COPY --from=installer /targeting-pack.rpm /targeting-pack.rpm
COPY --from=installer /aspnetcore-targeting-pack.rpm /aspnetcore-targeting-pack.rpm
COPY --from=installer /netstandard-targeting-pack.rpm /netstandard-targeting-pack.rpm

# Install .NET SDK
RUN tdnf install -y --disablerepo=* dotnet.rpm apphost.rpm targeting-pack.rpm aspnetcore-targeting-pack.rpm netstandard-targeting-pack.rpm \
    && rm dotnet.rpm apphost.rpm targeting-pack.rpm aspnetcore-targeting-pack.rpm netstandard-targeting-pack.rpm \
    # Trigger first run experience by running arbitrary cmd
    && dotnet help

# Install PowerShell global tool
RUN powershell_version=7.3.0-preview.8 \
    && curl -fSL --output PowerShell.Linux.x64.$powershell_version.nupkg https://pwshtool.blob.core.windows.net/tool/$powershell_version/PowerShell.Linux.x64.$powershell_version.nupkg \
    && powershell_sha512='96b99336691b393547567a604cbe2719214ad439e635717942a28a533492a699e487f4894637ccb7399a6e8d4160cd119a5f86aa664f8c423851b47a0fb4748b' \
    && echo "$powershell_sha512  PowerShell.Linux.x64.$powershell_version.nupkg" | sha512sum -c - \
    && mkdir -p /usr/share/powershell \
    && dotnet tool install --add-source / --tool-path /usr/share/powershell --version $powershell_version PowerShell.Linux.x64 \
    && dotnet nuget locals all --clear \
    && rm PowerShell.Linux.x64.$powershell_version.nupkg \
    && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
    && chmod 755 /usr/share/powershell/pwsh \
    # To reduce image size, remove the copy nupkg that nuget keeps.
    && find /usr/share/powershell -print | grep -i '.*[.]nupkg$' | xargs rm
