ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.9-alpine3.16-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.9-servicing.22419.5 \
    && wget -O dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.9-linux-musl-arm64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='3f5ca6d2e498e11bf1b46cf9ba456a4788a4dcb7ba4b0e52301bb9a3e2d511a8a9bd173be0cc8639c0297d90ad911a259da53ac2f6fd066313d79025ca42a5ef' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.9-alpine3.16-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=6.0.9-servicing.22419.5

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
