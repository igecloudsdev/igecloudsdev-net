ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:6.0.10-alpine3.16-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.10-servicing.22476.17 \
    && wget -O aspnetcore.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.10-linux-musl-arm64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='1cc24cf179bf391945fa78ed1311e90d06451c9ba918d742f3e0338d3a0aab1374a167e781c40c8e421be8369c55936c051ab59459298dcdeaf91df6643b35cc' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:6.0.10-alpine3.16-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.10-servicing.22476.17

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
