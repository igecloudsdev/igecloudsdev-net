ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM arm32v7/buildpack-deps:focal-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.10-servicing.22476.5 \
    && curl -fSL --output dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.10-linux-arm.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='75e6c380a00f253d06e33aae36403da2e31bdb4c41705455cbdb4aecee6cec05d7ab95ae90493f44e34360ffa00265a10e8295d780db8ae37225578afbcbead7' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.10-focal-arm32v7

# .NET Runtime version
ENV DOTNET_VERSION=6.0.10-servicing.22476.5

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
