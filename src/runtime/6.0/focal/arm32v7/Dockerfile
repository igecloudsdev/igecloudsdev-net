ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM arm32v7/buildpack-deps:focal-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.11-servicing.22523.4 \
    && curl -fSL --output dotnet.tar.gz https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22524-2-internal/Runtime/$dotnet_version/dotnet-runtime-6.0.11-linux-arm.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='a23ed056a95787c18ad95e7c3fa85fbba074536bad167e6aebf26136ab633fe491f2eb3bc20eafa62418e74a90bcee55f6dcd5a7cdc8d3dcc17ba66cd7059f3d' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.11-focal-arm32v7

# .NET Runtime version
ENV DOTNET_VERSION=6.0.11-servicing.22523.4

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
