ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-cbl-mariner2.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rtm.22518.5 \
    && curl -fSL --output dotnet-host.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/Runtime/$dotnet_version/dotnet-host-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='8753f346744bafb9aac2c90661e4773496c6f9b85afe85962cf5b3ad4501c165d5296bb5ecd50671e24050019a369d909fc41469b9bf53ec0a5e7884b1b10c79' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/Runtime/$dotnet_version/dotnet-hostfxr-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='6a2a0d927feb44b863eb2c9414676a412bca86eeeae9a755efa1ea172f3711bbd7d09da3d983e31e367595bad18365d43830e3c41c3bc902a5a6a5cf0d047f45' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/Runtime/$dotnet_version/dotnet-runtime-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='1b8698127377b3b4c5a7bb2be7c7d7534e55fc01c9d82f6c670c72747b53a9cb5f78ea3b89ea43e99c7c5ddd6f918dc1dd13707958b96731688a1df01d8e4a4b' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:7.0.0-cbl-mariner2.0-amd64

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rtm.22518.5

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN tdnf install -y --disablerepo=* dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
