ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM arm32v7/buildpack-deps:bullseye-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=7.0.0-rtm.22518.19 \
    && curl -fSL --output aspnetcore.tar.gz https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-7.0.0-linux-arm.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='560f1a38498f36ccd7429f74e0dfea9e14ab668fc1f916e16542ed3ea4d6a8344f8605143b3c6c8f99248496d77767abedd69a50802d5507324cad44eed6fb1b' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:7.0.0-bullseye-slim-arm32v7

# ASP.NET Core version
ENV ASPNET_VERSION=7.0.0-rtm.22518.19

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
