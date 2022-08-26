ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM arm32v7/buildpack-deps:jammy-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.9-servicing.22419.5 \
    && curl -fSL --output dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.9-linux-arm.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='9b1bc18f86d03e3c80dbc7fb1e8d091fd9b8346deaaca810f8057f6940f60facb9592297bdd8e7e9e3df0268bd0c46f1f7609e04ba0595ff489867665df535f9' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.9-jammy-arm32v7

# .NET Runtime version
ENV DOTNET_VERSION=6.0.9-servicing.22419.5

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
