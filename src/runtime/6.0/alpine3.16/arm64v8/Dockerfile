ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.11-alpine3.16-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.11-servicing.22523.4 \
    && wget -O dotnet.tar.gz https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22524-2-internal/Runtime/$dotnet_version/dotnet-runtime-6.0.11-linux-musl-arm64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='d1d74cefec7075ba9a1fb88cc53afa677c88275b1ad431df4fda78c7e239a42e1fc14f3c7dce50d8f5505419540062dda21537363d9797ae71317b6206a4e906' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.11-alpine3.16-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=6.0.11-servicing.22523.4

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
