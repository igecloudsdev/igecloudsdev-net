ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM $REPO:6.0.11-cbl-mariner1.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve ASP.NET Core
RUN aspnetcore_version=6.0.11-servicing.22523.4 \
    && curl -fSL --output aspnetcore.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22524-2-internal/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-6.0.11-x64.rpm$SAS_QUERY_STRING \
    && aspnetcore_sha512='f890da7fb82e3740bcf7a86e79f94c96a0e870b45b78056778126436e17e54a8549ee08dba655a079499204e9f6e9f0f5d20c517827f073b08f484ae21c977cb' \
    && echo "$aspnetcore_sha512  aspnetcore.rpm" | sha512sum -c -


# ASP.NET Core image
FROM $REPO:6.0.11-cbl-mariner1.0-amd64

# ASP.NET Core version
ENV ASPNET_VERSION=6.0.11-servicing.22523.4

COPY --from=installer /aspnetcore.rpm /aspnetcore.rpm

RUN rpm --install aspnetcore.rpm \
    && rm aspnetcore.rpm
