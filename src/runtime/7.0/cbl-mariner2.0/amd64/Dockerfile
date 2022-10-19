ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-cbl-mariner2.0-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rtm.22513.8 \
    && curl -fSL --output dotnet-host.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-host-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='7a903a355c989715eba9d2c35f351724ae77e9e0aad3cc50a84ac7058ec0def50f52b10208a3f5b49f8d0e99ce911130e219df812adcbbe1168c3a0d1142a825' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-hostfxr-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='ab6a5c6acd70e8af94f8bd72945b1792ae4000d46e760653f70260a30c2d31876706080d0d35bef42c43bf4ee87a28c89bc2ce2df492d0b856e0bfcfc59b8a78' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-7.0.0-x64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='dcfce282d896f880beecf44f29cf89243753b17dada8f0143f9ca59f0a832f18c4d70bf0eb48917939be2318e3225cb7106aa1e7e2a4a5a5560479d37a51ac1c' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:7.0.0-cbl-mariner2.0-amd64

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rtm.22513.8

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN tdnf install -y --disablerepo=* dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
