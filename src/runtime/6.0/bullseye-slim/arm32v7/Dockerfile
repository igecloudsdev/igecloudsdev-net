ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM arm32v7/buildpack-deps:bullseye-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.10-servicing.22469.10 \
    && curl -fSL --output dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.10-linux-arm.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='528c42c1e12a30ba1347e707ee1d269646fa6bd704c18b943e65d3e02389622390c6c988a0fd8282d1c66ea89334ddd0a871a604052e4d84e7868162621f2a84' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.10-bullseye-slim-arm32v7

# .NET Runtime version
ENV DOTNET_VERSION=6.0.10-servicing.22469.10

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
