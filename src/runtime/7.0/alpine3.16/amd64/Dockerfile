ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-rc.2-alpine3.16-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rc.2.22472.3 \
    && wget -O dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-$dotnet_version-linux-musl-x64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='751d4bbd08039dee405f92f3b2f5499ee65b6bb646124d5826a23b0979efb71848873f20dcbd3c6a66fc815c4f2bd1cfa9a6834dacb131350ac0f122b6b698b1' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:7.0.0-rc.2-alpine3.16-amd64

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rc.2.22472.3

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
