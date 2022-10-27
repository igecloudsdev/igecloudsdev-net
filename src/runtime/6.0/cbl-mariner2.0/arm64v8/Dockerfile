ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.11-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.11-servicing.22523.4 \
    && curl -fSL --output dotnet-host.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22524-2-internal/Runtime/$dotnet_version/dotnet-host-6.0.11-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='64d39ab49ad6175975b313c837e6c251a06f290a6af2a0fb4aed35b132663fec19569e4bc43bfe4b1e92f07aa45f0d546661887401f29ec34109af400db3ad13' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22524-2-internal/Runtime/$dotnet_version/dotnet-hostfxr-6.0.11-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='475b0987eb4a2e91f398d928a3e92d2cf26d47c4cc177a9de2bcc5b5a11440ed17c299c226763c3f4ee9397053ebee41c01055e8d0e67d16a5acc15d21eed87d' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22524-2-internal/Runtime/$dotnet_version/dotnet-runtime-6.0.11-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='20b6318c1e9b42e404b16cfcac62c7138290e8e5a9872139f78a29732ab4807a956c998092ca4110fa6c3a32ca0a50e4bbbc06dba7c52a51b2c4b9cb16aedd50' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:6.0.11-cbl-mariner2.0-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=6.0.11-servicing.22523.4

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN tdnf install -y --disablerepo=* dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
