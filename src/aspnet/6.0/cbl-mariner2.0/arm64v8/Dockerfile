ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:6.0.11-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.11-servicing.22518.17 \
    && curl -fSL --output aspnetcore.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.11-aarch64.rpm$SAS_QUERY_STRING \
    && aspnetcore_sha512='d3336e9da99e2f2d8dc2182bca8d62fc9f3dd8b241e36b12551ce855ce0fcec22b7876d8e248ed3c62178e0580fbabf8c49dc73183f113318153273e48f58b0e' \
    && echo "$aspnetcore_sha512  aspnetcore.rpm" | sha512sum -c -


# ASP.NET Core image
FROM $REPO:6.0.11-cbl-mariner2.0-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.11-servicing.22518.17

COPY --from=installer /aspnetcore.rpm /aspnetcore.rpm

RUN tdnf install -y --disablerepo=* aspnetcore.rpm \
    && rm aspnetcore.rpm
