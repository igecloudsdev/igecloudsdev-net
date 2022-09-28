ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-rc.2-alpine3.16-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rc.2.22472.3 \
    && wget -O dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-$dotnet_version-linux-musl-arm64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='ffac2009a9c2f9df27a3778bdb990f30da27f89a11c1c9c7296fa49c5a02b20cb508d515c2a613d71c59ff1b77ffea868b3837899bfc2dc6796bb159e824611e' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:7.0.0-rc.2-alpine3.16-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rc.2.22472.3

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
