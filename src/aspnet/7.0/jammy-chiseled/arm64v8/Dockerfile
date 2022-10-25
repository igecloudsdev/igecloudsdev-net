ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM arm64v8/buildpack-deps:jammy-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=7.0.0-rtm.22518.19 \
    && curl -fSL --output aspnetcore.tar.gz https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22521-12-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-7.0.0-linux-arm64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='ffee38cb0c8fd3ba20f3d814b7e141f94be18620eb91a229b80d7c609f6cad77efb7f8f276e9fbee4f3ed8cce33cc0659f0dc77faeb8f5427c95deead97275d7' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf aspnetcore.tar.gz -C /dotnet ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:7.0.0-jammy-chiseled-arm64v8

# ASP.NET Core version
ENV ASPNET_VERSION=7.0.0-rtm.22518.19

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]
