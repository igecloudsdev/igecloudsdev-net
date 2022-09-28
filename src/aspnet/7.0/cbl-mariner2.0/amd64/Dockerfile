ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:7.0.0-rc.2-cbl-mariner2.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=7.0.0-rc.2.22476.2 \
    && curl -fSL --output aspnetcore.rpm https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-$aspnetcore_version-x64.rpm$SAS_QUERY_STRING \
    && aspnetcore_sha512='a969fd5ceb4769fcc75cf9edd0c2627cf5e181379954dc1bf6453dd631dc2ec7754403b9f7a7e253cf57867004ecc047f68cce775d5793556a1b91c565fce17b' \
    && echo "$aspnetcore_sha512  aspnetcore.rpm" | sha512sum -c -


# ASP.NET Core image
FROM $REPO:7.0.0-rc.2-cbl-mariner2.0-amd64

# ASP.NET Core version
ENV ASPNET_VERSION=7.0.0-rc.2.22476.2

COPY --from=installer /aspnetcore.rpm /aspnetcore.rpm

RUN tdnf install -y --disablerepo=* aspnetcore.rpm \
    && rm aspnetcore.rpm
