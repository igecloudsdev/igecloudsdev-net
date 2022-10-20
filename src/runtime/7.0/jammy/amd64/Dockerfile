ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM amd64/buildpack-deps:jammy-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rtm.22518.5 \
    && curl -fSL --output dotnet.tar.gz https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Runtime/$dotnet_version/dotnet-runtime-7.0.0-linux-x64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='f4a6e9d5fec7d390c791f5ddaa0fcda386a7ec36fe2dbaa6acb3bdad38393ca1f9d984dd577a081920c3cae3d511090a2f2723cc5a79815309f344b8ccce6488' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:7.0.0-jammy-amd64

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rtm.22518.5

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
