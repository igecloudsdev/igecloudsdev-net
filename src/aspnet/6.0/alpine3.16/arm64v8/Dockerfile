ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:6.0.11-alpine3.16-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.11-servicing.22518.17 \
    && wget -O aspnetcore.tar.gz https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.11-linux-musl-arm64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='6b2d5709880f7f18b0547bf8341f7115fd099df4a37007fbf5e46cd8c967ee6170537a48f71e621ee16a45804ea80c3a870f9e3a765160771ee31aae19f8745b' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:6.0.11-alpine3.16-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.11-servicing.22518.17

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
