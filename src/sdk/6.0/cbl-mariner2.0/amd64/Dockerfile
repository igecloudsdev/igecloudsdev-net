ARG REPO=mcr.microsoft.com/dotnet/aspnet
# Installer image
FROM $REPO:6.0.9-cbl-mariner2.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Install .NET SDK
RUN curl -fSL --output dotnet.rpm https://dotnetbuilds.blob.core.windows.net/internal/Sdk/6.0.401-servicing.22421.13/dotnet-sdk-6.0.401-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='7fdd6e700e1a4266f979782cffa7cca4f4210a7f110559e0052c7fc4192fa40a758c34606406ba21040e2465a7ad9c0aa6cc89b76aa6d4fecf198f98112f514c' \
    && echo "$dotnet_sha512  dotnet.rpm" | sha512sum -c - \
    \
    && curl -fSL --output apphost.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$DOTNET_VERSION/dotnet-apphost-pack-6.0.9-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='2bb03bde7dd73642b888cf5aca47fd5f620150188de0602ce74f27c7d3f70ff2caa8f4c9e63492384fca1c7c16baf24eaa63eb38c8c7b2ad63929dcd53e37d20' \
    && echo "$dotnet_sha512  apphost.rpm" | sha512sum -c - \
    \
    && curl -fSL --output targeting-pack.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/6.0.9-servicing.22419.5/dotnet-targeting-pack-6.0.9-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='e3a3d845ffaa07d77d9f97d7707cd723d7e180d352dc690fb78b91b804736b4c43e68a467043104d24c6ce5536d869b1170a3aca52735695587ad6fec8e015df' \
    && echo "$dotnet_sha512  targeting-pack.rpm" | sha512sum -c - \
    \
    && curl -fSL --output aspnetcore-targeting-pack.rpm https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/6.0.9-servicing.22419.26/aspnetcore-targeting-pack-6.0.9-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='8f0f9ef96be61f2a59472a3b6c87925876020854f7ad184dbbe331275d98617ff1420fce2601ce8ebc6b523a38e89894bc79ebe4578a735e75460b30b4255a1d' \
    && echo "$dotnet_sha512  aspnetcore-targeting-pack.rpm" | sha512sum -c - \
    \
    && curl -fSL --output netstandard-targeting-pack.rpm https://dotnetcli.azureedge.net/dotnet/Runtime/3.1.0/netstandard-targeting-pack-2.1.0-x64.rpm \
    && dotnet_sha512='fab41a86b9182b276992795247868c093890c6b3d5739376374a302430229624944998e054de0ff99bddd9459fc9543636df1ebd5392db069ae953ac17ea2880' \
    && echo "$dotnet_sha512  netstandard-targeting-pack.rpm" | sha512sum -c -


# .NET SDK image
FROM $REPO:6.0.9-cbl-mariner2.0-amd64

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
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-CBL-Mariner-2.0

RUN tdnf install -y \
        git \
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
