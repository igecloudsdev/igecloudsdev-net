ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.9-alpine3.16-arm32v7 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.9-servicing.22419.5 \
    && wget -O dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.9-linux-musl-arm.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='f8baf7dbda54b29c37082f604e6b96ef3d5d6e22bc46cc52d6e8226bb6fc91449584f3203f4f2f5d20df11caa3846e46d6d6c80adddf49577d7b29d405a31d4d' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.9-alpine3.16-arm32v7

# .NET Runtime version
ENV DOTNET_VERSION=6.0.9-servicing.22419.5

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
