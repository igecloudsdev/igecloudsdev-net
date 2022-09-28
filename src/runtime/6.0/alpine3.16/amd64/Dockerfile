ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.10-alpine3.16-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.10-servicing.22469.10 \
    && wget -O dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.10-linux-musl-x64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='4fad7643e8f43b00860d6e5fe989fbf67ab11baebe33023b0e9b0aae4896a6da3533c0d471c2cc8488873f0c9b74f2acaf533d817d4001371d3cecd30ab34a17' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.10-alpine3.16-amd64

# .NET Runtime version
ENV DOTNET_VERSION=6.0.10-servicing.22469.10

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
