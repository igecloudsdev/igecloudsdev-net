ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:7.0.0-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=7.0.0-rtm.22518.19 \
    && curl -fSL --output aspnetcore.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-7.0.0-aarch64.rpm$SAS_QUERY_STRING \
    && aspnetcore_sha512='bb341001e45e08486ceda80cf0243c4289f0d8d6a530827511789490aafcf8698bc88464593e6ae925050537c9f56129c5d1db05c1ec599c8ec9ef87b6adfcaa' \
    && echo "$aspnetcore_sha512  aspnetcore.rpm" | sha512sum -c -


# ASP.NET Core image
FROM $REPO:7.0.0-cbl-mariner2.0-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=7.0.0-rtm.22518.19

COPY --from=installer /aspnetcore.rpm /aspnetcore.rpm

RUN tdnf install -y --disablerepo=* aspnetcore.rpm \
    && rm aspnetcore.rpm
