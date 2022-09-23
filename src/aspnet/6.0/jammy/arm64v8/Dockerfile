ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM arm64v8/buildpack-deps:jammy-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.10-servicing.22469.29 \
    && curl -fSL --output aspnetcore.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.10-linux-arm64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='90b1a1bf241271ad32fa7b9953b3ba0fa06ddd432237c0e0e6ae3e9badd313299f5da93abee087f4f7b5a5e49955d9f8d15a8b18c9b58b2400715f84c7bb6776' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:6.0.10-jammy-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.10-servicing.22469.29

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
