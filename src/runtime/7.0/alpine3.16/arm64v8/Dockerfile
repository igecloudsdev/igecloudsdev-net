ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-alpine3.16-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rtm.22518.5 \
    && wget -O dotnet.tar.gz https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22521-12-internal/Runtime/$dotnet_version/dotnet-runtime-7.0.0-linux-musl-arm64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='8e51878ff716d56366c52af7ff92375d3df796ceb56a74ff88fce6c3461003ed05be1ed6504c0d7d217afdce1097895c8df508d4c64d7fae537ff53482c3f8ca' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:7.0.0-alpine3.16-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rtm.22518.5

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
