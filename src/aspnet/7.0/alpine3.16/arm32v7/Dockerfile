ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:7.0.0-alpine3.16-arm32v7 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=7.0.0-rtm.22518.19 \
    && wget -O aspnetcore.tar.gz https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-7.0.0-linux-musl-arm.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='e3e66099bc70e87902c35b5b84efec471b31d2607789088bb94b4aa903b518376879c683dc501486a43a1713afe77a437d0e3fef956abfb6005e1c73e355c9dc' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:7.0.0-alpine3.16-arm32v7

# ASP.NET Core version
ENV ASPNET_VERSION=7.0.0-rtm.22518.19

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
