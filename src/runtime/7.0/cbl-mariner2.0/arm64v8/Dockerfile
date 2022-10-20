ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rtm.22518.5 \
    && curl -fSL --output dotnet-host.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Runtime/$dotnet_version/dotnet-host-7.0.0-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='59eb8941a167a213097c54d3e98d92478caba3c516df98b7fa44a62f5d2d38763d20e06fcd46c3f12ced3455b84ae3af832ba18afa6e861f6ccdbc1060417f41' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Runtime/$dotnet_version/dotnet-hostfxr-7.0.0-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='21ea3c59d4dcbe9b3bafa535d30a6c7e83d8a0d2a863965f2d6b624c19cbde469f13b8c7e3a2833b8925e416c85286cee379ee74201d245a4b65a36eb129909a' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Runtime/$dotnet_version/dotnet-runtime-7.0.0-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='ff756be2c993e4f80fa76409b8f9c6ada66f79a003e13350667c99fc3e6e4a8e3e1948c37973ab2b7fcd062132fef3c3fbf3ba8e8d1e52fff2048085e92e1a3a' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:7.0.0-cbl-mariner2.0-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rtm.22518.5

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN tdnf install -y --disablerepo=* dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
