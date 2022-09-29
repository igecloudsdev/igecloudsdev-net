ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM arm64v8/buildpack-deps:bullseye-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.10-servicing.22476.5 \
    && curl -fSL --output dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.10-linux-arm64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='94d182d2d80f3cc9caabbd12e3afeef4af93269a331b64276985496e4a77040785c25b85c58cfc8093f4199e8c6da6de8128157dadfed41c82d991f57df7afdd' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.10-bullseye-slim-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=6.0.10-servicing.22476.5

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
