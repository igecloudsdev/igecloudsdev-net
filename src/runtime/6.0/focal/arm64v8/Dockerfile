ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM arm64v8/buildpack-deps:focal-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.11-servicing.22518.9 \
    && curl -fSL --output dotnet.tar.gz https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/Runtime/$dotnet_version/dotnet-runtime-6.0.11-linux-arm64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='09bbb5c29c76edfc430eb638339338d68127018626665d51cecfd33c341c586c7014305cc26fa21f03e986e20c1d5cd585bdcce308904a46f3dff9977378f806' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.11-focal-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=6.0.11-servicing.22518.9

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
