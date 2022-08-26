ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM amd64/buildpack-deps:focal-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.9-servicing.22419.26 \
    && curl -fSL --output aspnetcore.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.9-linux-x64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='e808036155bc324335c309aaf948b2be1940a62eaf0135752989644698653c8f3a5ce310c3ee6742e3af73dbe175c6e529298eedf6eeb31cc38bfeab628f6d7b' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:6.0.9-focal-amd64

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.9-servicing.22419.26

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
