ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:6.0.11-alpine3.16-arm32v7 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.11-servicing.22523.4 \
    && wget -O aspnetcore.tar.gz https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22524-2-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.11-linux-musl-arm.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='89f0a447bc2083228bd5ed59fdc7c113608266f23ab9e793458a2ab1afc13d201c1b476792d6841e29ebedcb86c6a1b064aae041aa1e37959f41079929f0aa4a' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:6.0.11-alpine3.16-arm32v7

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.11-servicing.22523.4

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
