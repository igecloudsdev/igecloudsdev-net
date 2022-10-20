ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:7.0.0-cbl-mariner2.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=7.0.0-rtm.22518.19 \
    && curl -fSL --output aspnetcore.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && aspnetcore_sha512='705486e34a63a014e553675237f3fcf93a4edde38604b618c13eecf31196a26a0032e2d39c4630846e42dc4832975d2bfb937da8a7c1ffcc372d0de2179dfb0a' \
    && echo "$aspnetcore_sha512  aspnetcore.rpm" | sha512sum -c -


# ASP.NET Core image
FROM $REPO:7.0.0-cbl-mariner2.0-amd64

# ASP.NET Core version
ENV ASPNET_VERSION=7.0.0-rtm.22518.19

COPY --from=installer /aspnetcore.rpm /aspnetcore.rpm

RUN tdnf install -y --disablerepo=* aspnetcore.rpm \
    && rm aspnetcore.rpm
