ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:6.0.10-cbl-mariner1.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.10-servicing.22469.29 \
    && curl -fSL --output aspnetcore.rpm https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.10-x64.rpm$SAS_QUERY_STRING \
    && aspnetcore_sha512='60d84548ac0d11577f36f4e7e26654f0f5606fa0a14a04098445fb6c3065456ba0d5bdc87a0008d65a71b6542806b8c6f663e911b01bc8cec135b9037f2098c1' \
    && echo "$aspnetcore_sha512  aspnetcore.rpm" | sha512sum -c -


# ASP.NET Core image
FROM $REPO:6.0.10-cbl-mariner1.0-amd64

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.10-servicing.22469.29

COPY --from=installer /aspnetcore.rpm /aspnetcore.rpm

RUN rpm --install aspnetcore.rpm \
    && rm aspnetcore.rpm
