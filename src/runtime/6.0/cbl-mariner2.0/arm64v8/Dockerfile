ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.11-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.11-servicing.22518.9 \
    && curl -fSL --output dotnet-host.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/Runtime/$dotnet_version/dotnet-host-6.0.11-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='9e03943730b620e0ae40ae51a6fa7bedb4cb12066d075422ed270c1c7af9577260d865061c8fb61e775ef6609dca2cbfb651c9e4c4d58899067e94765a1c970e' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/Runtime/$dotnet_version/dotnet-hostfxr-6.0.11-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='7b5840d9470bb4813a50b0835e9b47550a4ed875764a33cf9ad6d981632bb062f9e5c472222ca942c600bbb20fab683f31ad35c5915b26c4d6ea39c5f71a854c' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/Runtime/$dotnet_version/dotnet-runtime-6.0.11-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='447f5212a675426e9f95edb2e74ec2358fccbcfde5d97f355f53a524e90be1fc2e9127783ee40f8b3410608dd8608160296e0d80be9ea603a5096a97b17beb2c' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:6.0.11-cbl-mariner2.0-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=6.0.11-servicing.22518.9

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN tdnf install -y --disablerepo=* dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
