ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:6.0.10-alpine3.16-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.10-servicing.22469.29 \
    && wget -O aspnetcore.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.10-linux-musl-arm64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='371233274b594ffa76db6ad1016e8dc6c1a558e74a1f8398cdeafa394e26dddd7836f210113064be65efb91a8fa89f8e8e934421c742bbe92f8ba697cb304463' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:6.0.10-alpine3.16-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.10-servicing.22469.29

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
