ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.11-alpine3.16-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.11-servicing.22518.9 \
    && wget -O dotnet.tar.gz https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/Runtime/$dotnet_version/dotnet-runtime-6.0.11-linux-musl-arm64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='a9e811deb2ec6e77cbb1e8da100421abd9fbad4ce389f6126e50a3d628fb2596114039b7ee6dddc8c5e1de3888e1cb790c04b284834f84665af6c2b810b3a30f' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.11-alpine3.16-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=6.0.11-servicing.22518.9

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
