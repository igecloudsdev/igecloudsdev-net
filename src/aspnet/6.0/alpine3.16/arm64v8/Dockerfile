ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:6.0.9-alpine3.16-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.9-servicing.22419.26 \
    && wget -O aspnetcore.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.9-linux-musl-arm64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='55945e23e2f4140af61f785a47ee15ec94880d52683e1881fb184b2341a1ecf8e04650e1fd896dd44d9493fe0fd3a9365f10dadb897560f42f1bc4cf5b7b9924' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:6.0.9-alpine3.16-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.9-servicing.22419.26

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
