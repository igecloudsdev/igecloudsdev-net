ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM amd64/buildpack-deps:bullseye-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.11-servicing.22523.4 \
    && curl -fSL --output aspnetcore.tar.gz https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22524-2-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.11-linux-x64.tar.gz$SAS_QUERY_STRING \
    && aspnetcore_sha512='12a30719aacd5b3dd444d075c13966a4bb1dc149c36bcbc0e685730f08d1c75eb3929749b89a88569ddb48bd8104db84aaee2ee097ac3a5fe6fff60c9f09f741' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz


# ASP.NET Core image
FROM $REPO:6.0.11-bullseye-slim-amd64

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.11-servicing.22523.4

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
