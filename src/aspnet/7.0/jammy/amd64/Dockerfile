ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM amd64/buildpack-deps:jammy-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=7.0.0-rtm.22518.19 \
    && curl -fSL --output aspnetcore.tar.gz https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-7.0.0-linux-x64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='02ce2e0b3c4b1d0eb0d9bdb9517a3293404b2a1aaf23311e305b856bb15723414f6328887788b875f0f80361f3e195c872ea3984971e5f0ab1ad5de43950d707' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:7.0.0-jammy-amd64

# ASP.NET Core version
ENV ASPNET_VERSION=7.0.0-rtm.22518.19

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
