ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM arm64v8/buildpack-deps:jammy-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=7.0.0-rtm.22517.16 \
    && curl -fSL --output aspnetcore.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-7.0.0-linux-arm64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='a3f33fd29caf3be71c6e03bc24cab0f46cb45e6d3dc499cfee8c8d9ed2e66cf2a2effdbb3b673a3d12eba5323359b58b1b41e009af4ff3f3f37e2ef4b4e1ec4c' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf aspnetcore.tar.gz -C /dotnet ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:7.0.0-jammy-chiseled-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=7.0.0-rtm.22517.16

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]
