ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM arm32v7/buildpack-deps:jammy-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.10-servicing.22476.17 \
    && curl -fSL --output aspnetcore.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.10-linux-arm.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='48d590741a8d648c20e130d3934e6e4a8a4d7ce750c7c74cf4eac77fe969798c36d8780c006baa1514e0b341d3e3cd5a6a3860f484762fc703577d35b1b92202' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:6.0.10-jammy-arm32v7

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.10-servicing.22476.17

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
