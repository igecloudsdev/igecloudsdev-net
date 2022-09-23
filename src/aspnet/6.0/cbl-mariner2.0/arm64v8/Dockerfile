ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:6.0.10-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.10-servicing.22469.29 \
    && curl -fSL --output aspnetcore.rpm https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.10-aarch64.rpm$SAS_QUERY_STRING \
    && aspnetcore_sha512='14ae2a73f029beca96cc4c845f07ca755d568775b5a294161687dcf7a01fb3e0ae77c3cfb0ad50be388b1f240f9dbcee37aabd39aacf43771f9054c66746f581' \
    && echo "$aspnetcore_sha512  aspnetcore.rpm" | sha512sum -c -


# ASP.NET Core image
FROM $REPO:6.0.10-cbl-mariner2.0-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.10-servicing.22469.29

COPY --from=installer /aspnetcore.rpm /aspnetcore.rpm

RUN tdnf install -y --disablerepo=* aspnetcore.rpm \
    && rm aspnetcore.rpm
