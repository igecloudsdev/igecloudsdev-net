ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:6.0.11-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.11-servicing.22523.4 \
    && curl -fSL --output aspnetcore.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22524-2-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.11-aarch64.rpm$SAS_QUERY_STRING \
    && aspnetcore_sha512='b1b33c92a068e1d629873f54355e9da3e18410c0e3452248b3a8f5fc074d8ace32616a7f703af48a274871545287f723ae971fba9a379cd39b1003f5b348b6e8' \
    && echo "$aspnetcore_sha512  aspnetcore.rpm" | sha512sum -c -


# ASP.NET Core image
FROM $REPO:6.0.11-cbl-mariner2.0-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.11-servicing.22523.4

COPY --from=installer /aspnetcore.rpm /aspnetcore.rpm

RUN tdnf install -y --disablerepo=* aspnetcore.rpm \
    && rm aspnetcore.rpm
