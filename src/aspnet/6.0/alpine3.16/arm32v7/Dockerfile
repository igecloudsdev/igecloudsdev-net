ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:6.0.9-alpine3.16-arm32v7 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.9-servicing.22419.26 \
    && wget -O aspnetcore.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.9-linux-musl-arm.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='03703940ddcbdb45350d09cea211380660f831be68c1d50492f98d97e77ff0aad706ca59cd15c260164d5134f92b724d45846f79edc0dea049da18b8e43c1052' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:6.0.9-alpine3.16-arm32v7

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.9-servicing.22419.26

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
