ARG REPO=mcr.microsoft.com/dotnet/aspnet
# Installer image
FROM $REPO:6.0.10-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Install .NET SDK
RUN curl -fSL --output dotnet.rpm https://dotnetbuilds.blob.core.windows.net/internal/Sdk/6.0.402-servicing.22470.36/dotnet-sdk-6.0.402-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='6e6f038d9872369627f86aa243c68240e9271ed32a20353cfdf3d65fbadd6b84997d680eebeb22ec24fc4a5f1e6cb1a103ae8dda8f8d4feec786fb90bca12961' \
    && echo "$dotnet_sha512  dotnet.rpm" | sha512sum -c - \
    \
    && curl -fSL --output apphost.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$DOTNET_VERSION/dotnet-apphost-pack-6.0.10-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='59fe2b1cd3df6bad641e3e3aff4c2ea47ace9c02d2533e14536ee92d4942fa1d46646db60f4c92b35dc786ab2c98134e9367e56c4ed15dc96d9810a49445eee6' \
    && echo "$dotnet_sha512  apphost.rpm" | sha512sum -c - \
    \
    && curl -fSL --output targeting-pack.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/6.0.10-servicing.22469.10/dotnet-targeting-pack-6.0.10-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='ec6c3b98ff217c885da36c22ece1bf9305826462f31d5f7ab3df14013c20cc0d87bfa1ea31d207b4dafde89e74d3c4c7239dbf111528f9dfe5b2635359243146' \
    && echo "$dotnet_sha512  targeting-pack.rpm" | sha512sum -c - \
    \
    && curl -fSL --output aspnetcore-targeting-pack.rpm https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/6.0.10-servicing.22469.29/aspnetcore-targeting-pack-6.0.10-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='f4a87e369af6f2af688d35ec6999483b4257d34b5e755a90bd6daa5be53c1de3376a1897c7f828fee2be62c71272be2d1a9f437234b42db9423093c256bb8065' \
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
    DOTNET_SDK_VERSION=6.0.402-servicing.22470.36 \
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
