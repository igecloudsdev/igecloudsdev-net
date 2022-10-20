ARG REPO=mcr.microsoft.com/dotnet/aspnet
# Installer image
FROM $REPO:7.0.0-cbl-mariner2.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Install .NET SDK
RUN curl -fSL --output dotnet.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Sdk/7.0.100-rtm.22519.28/dotnet-sdk-7.0.100-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='55cd936d71d22a517482f3a684e7360b56e49cb2f9d8a8a343efb7ce253113e265036cefa6329191997aa12304245dbdabc084a0819ec9a81d23d99348a6b9b0' \
    && echo "$dotnet_sha512  dotnet.rpm" | sha512sum -c - \
    \
    && curl -fSL --output apphost.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Runtime/$DOTNET_VERSION/dotnet-apphost-pack-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='3ce5f029f00a9c8b910616a78200e5c133ece1c0e3a7ae0f95ce53174cb833c656137325541a581a7645b841d014fc414a8b63765578467bc710b200611b2335' \
    && echo "$dotnet_sha512  apphost.rpm" | sha512sum -c - \
    \
    && curl -fSL --output targeting-pack.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Runtime/7.0.0-rtm.22518.5/dotnet-targeting-pack-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='f8b886e9b8ce802e358078384df575278e062c976908420601ba53822897ab8be58f5768d35dbc3788f80b63cd0b63a7dd17e2a6624cb1ea61ffb87e2eb76569' \
    && echo "$dotnet_sha512  targeting-pack.rpm" | sha512sum -c - \
    \
    && curl -fSL --output aspnetcore-targeting-pack.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/aspnetcore/Runtime/7.0.0-rtm.22518.19/aspnetcore-targeting-pack-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='5201da5eddfbe877169a7d34a5a0e564d48a1f26d583a5e2d9944fd3b7bf102729b476cdefa39d9233b602ec4aa2b0dfaa6cb41e1962a7471883fd53f297f2a6' \
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
    DOTNET_SDK_VERSION=7.0.100-rtm.22519.28 \
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
