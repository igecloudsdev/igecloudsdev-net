ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM arm64v8/buildpack-deps:jammy-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.10-servicing.22476.17 \
    && curl -fSL --output aspnetcore.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.10-linux-arm64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='254796814f5810c416361046aada833a151c946b0dda12d10d1ac792db8528b64eed4bb8195d99081639f22b2114489df0d4bae20da3fe6c63987cafe0349b2d' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf aspnetcore.tar.gz -C /dotnet ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:6.0.10-jammy-chiseled-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.10-servicing.22476.17

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]
