ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:6.0.9-cbl-mariner1.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.9-servicing.22419.26 \
    && curl -fSL --output aspnetcore.rpm https://dotnetbuilds.blob.core.windows.net/internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.9-x64.rpm$SAS_QUERY_STRING \
    && aspnetcore_sha512='8cee2325485cdee7bd912ecca8e1c8e7092f088e4439a0fdbcd7ee1e6cbe13d1dc0d0446c50f695300acfef642e2a5d978e1476a028a894227ec9c626a080163' \
    && echo "$aspnetcore_sha512  aspnetcore.rpm" | sha512sum -c -


# ASP.NET Core image
FROM $REPO:6.0.9-cbl-mariner1.0-amd64

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.9-servicing.22419.26

COPY --from=installer /aspnetcore.rpm /aspnetcore.rpm

RUN rpm --install aspnetcore.rpm \
    && rm aspnetcore.rpm
