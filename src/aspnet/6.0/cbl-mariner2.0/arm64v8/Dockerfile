ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:6.0.10-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.10-servicing.22476.17 \
    && curl -fSL --output aspnetcore.rpm https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.10-aarch64.rpm$SAS_QUERY_STRING \
    && aspnetcore_sha512='fb7b433468691450a9c4c4d567a8bc238555491b5d1e4507bffb2b0955148aaf7528e227eef228fb2675c81dd87fd6c5de1b4dffee01fb4c5b6e2631b09dd442' \
    && echo "$aspnetcore_sha512  aspnetcore.rpm" | sha512sum -c -


# ASP.NET Core image
FROM $REPO:6.0.10-cbl-mariner2.0-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.10-servicing.22476.17

COPY --from=installer /aspnetcore.rpm /aspnetcore.rpm

RUN tdnf install -y --disablerepo=* aspnetcore.rpm \
    && rm aspnetcore.rpm
