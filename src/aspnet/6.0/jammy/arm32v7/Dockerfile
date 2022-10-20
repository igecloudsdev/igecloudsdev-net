ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM arm32v7/buildpack-deps:jammy-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.11-servicing.22518.17 \
    && curl -fSL --output aspnetcore.tar.gz https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.11-linux-arm.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='0efa635573f8becb3c66f6c738e1dfad0a18725084265656674fc2379807926671df95ae9facab257a39d482fb434dc719b4e833efc5e8d37c195df0b15b1eca' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:6.0.11-jammy-arm32v7

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.11-servicing.22518.17

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
