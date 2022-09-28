ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.10-alpine3.16-arm32v7 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.10-servicing.22469.10 \
    && wget -O dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.10-linux-musl-arm.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='caf69a49a4c51cf0a53416d9cef40f7fc168d38f2bb2d6cc5d26633bf61a0ee11fd8a0b0d19d1685ef5c931591caae540566d29332ba1160c270d36a64d62f33' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.10-alpine3.16-arm32v7

# .NET Runtime version
ENV DOTNET_VERSION=6.0.10-servicing.22469.10

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
