ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:7.0.0-cbl-mariner2.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=7.0.0-rtm.22518.19 \
    && curl -fSL --output aspnetcore.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && aspnetcore_sha512='442a15e79f0c2bba4488226f41a80ba4b5bcebf5568ca35f241a8d1ddc6f89136e3086580c3f2d7911d39547b48986bc4ba3716f88abb6852bef0281c789dc34' \
    && echo "$aspnetcore_sha512  aspnetcore.rpm" | sha512sum -c -


# ASP.NET Core image
FROM $REPO:7.0.0-cbl-mariner2.0-amd64

# ASP.NET Core version
ENV ASPNET_VERSION=7.0.0-rtm.22518.19

COPY --from=installer /aspnetcore.rpm /aspnetcore.rpm

RUN tdnf install -y --disablerepo=* aspnetcore.rpm \
    && rm aspnetcore.rpm
