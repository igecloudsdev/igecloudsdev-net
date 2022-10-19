ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:7.0.0-alpine3.16-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=7.0.0-rtm.22517.16 \
    && wget -O aspnetcore.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-7.0.0-linux-musl-arm64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='63a36baf9eea78f1c72a0b8b070773743269cfe78a7b0f73833cb26431e3ce5c32eed00f99f84752c3be70c186a54511862512984fb98230bd9b8670ece48779' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:7.0.0-alpine3.16-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=7.0.0-rtm.22517.16

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
