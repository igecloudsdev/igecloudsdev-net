ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-alpine3.16-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rtm.22513.8 \
    && wget -O dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-7.0.0-linux-musl-x64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='698e4ecfa5d4b3d655fc781d57e6808042723567d2460d718a3ec3b7c455d38f02c8497e263056036a0d079a17ecb5b7bdc19c849b82d6aac976aaa5920ff535' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:7.0.0-alpine3.16-amd64

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rtm.22513.8

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
