ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:6.0.11-cbl-mariner1.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.11-servicing.22518.17 \
    && curl -fSL --output aspnetcore.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.11-x64.rpm$SAS_QUERY_STRING \
    && aspnetcore_sha512='66ed2f8544b057b839e126091dc87c2e6eb5dd6e72c94864687a19fd825a0e2e56bb067baf5aaff83a0560e747322ec1129d3dd9568f0b211a7a866e5a24fdc6' \
    && echo "$aspnetcore_sha512  aspnetcore.rpm" | sha512sum -c -


# ASP.NET Core image
FROM $REPO:6.0.11-cbl-mariner1.0-amd64

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.11-servicing.22518.17

COPY --from=installer /aspnetcore.rpm /aspnetcore.rpm

RUN rpm --install aspnetcore.rpm \
    && rm aspnetcore.rpm
