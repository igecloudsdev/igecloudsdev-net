ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-cbl-mariner2.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rtm.22518.5 \
    && curl -fSL --output dotnet-host.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Runtime/$dotnet_version/dotnet-host-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='b6f517db1d82740032c1a5bdce77246a17ecb9b2b32c9cfea23bf4d2360437d4147fb9102b93d2b2369c77681d681418d044708790c43d94f44c3c0af0f43d54' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Runtime/$dotnet_version/dotnet-hostfxr-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='7d440b4e6563be8b5bf8abf1f5c33bc5ad22f9c8b3ad57fac946f2f0db182b254cc9ae37e54a51c401f647935bac62746f3019a399864d9d3d1c6b3c97062cda' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Runtime/$dotnet_version/dotnet-runtime-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='5b051b198fafe01c8613c649c3ee2046ac177c2178ddfa7a69b28354f26a5da1e5d94403f352c7fcba7f7698a3e2960f120427628ccf6b20d5dfd5f6a2474837' \
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
