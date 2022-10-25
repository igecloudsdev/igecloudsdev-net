ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-alpine3.16-arm32v7 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rtm.22518.5 \
    && wget -O dotnet.tar.gz https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22521-12-internal/Runtime/$dotnet_version/dotnet-runtime-7.0.0-linux-musl-arm.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='3d3c3a62f6e1b457604c5d642ac79027d804d2a816860f020806f77432d9e2a402dcde45c98aea68a2ec93ea97161f65222186e4bafee58d72e8122de941ce61' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:7.0.0-alpine3.16-arm32v7

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rtm.22518.5

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
