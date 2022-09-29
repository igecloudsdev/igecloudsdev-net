ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-rc.2-alpine3.16-arm32v7 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rc.2.22472.3 \
    && wget -O dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-$dotnet_version-linux-musl-arm.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='a18510d2db32bfd917b61e6c0aceb852eb9847f1bc9c228cb3057bcbcf2fe1456ef575bceca44e8dce0e8dc2ae079cdb4fdc293ffd1b3a38d7c07088778ad789' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:7.0.0-rc.2-alpine3.16-arm32v7

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rc.2.22472.3

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
