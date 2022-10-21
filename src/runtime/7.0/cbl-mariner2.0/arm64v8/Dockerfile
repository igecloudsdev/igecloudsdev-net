ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rtm.22518.5 \
    && curl -fSL --output dotnet-host.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/Runtime/$dotnet_version/dotnet-host-7.0.0-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='8a922baeecc11180a9539afa1dac3cd95addf29148049ab4f10c84bb00a8c4a868f37d52ad7b27822acce7d200a7bff260613b3db0c8e49817061db1b6cb9274' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/Runtime/$dotnet_version/dotnet-hostfxr-7.0.0-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='7ebd05032d72daa63f9bcee0e0097cba9b9d8fe3df97a39100d35cb817cf42edaaa400d72dd0b9f13533f6c7df1adc07d2ac3f8c6a90d48edc9a663fa3ada90c' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22520-10-internal/Runtime/$dotnet_version/dotnet-runtime-7.0.0-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='40c65483d9f98636607c63b4654d04f58d0d58bfa07caaa36748b3bacbd1fcaaaab970ad54acd93fe33a565d389ff4af6d593369e094f75b8e6ef59937aa371f' \
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
