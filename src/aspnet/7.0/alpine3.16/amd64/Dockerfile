ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:7.0.0-alpine3.16-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=7.0.0-rtm.22518.19 \
    && wget -O aspnetcore.tar.gz https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-7.0.0-linux-musl-x64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='099cd5b3078f50036e5a638a83aaef987fa1a01f593986cca97ee35c8cb4e2707bf49559ae1bc55cf063d5f8ac2d9a1ec1b64371e075550faf47febeadc9bb47' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:7.0.0-alpine3.16-amd64

# ASP.NET Core version
ENV ASPNET_VERSION=7.0.0-rtm.22518.19

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
