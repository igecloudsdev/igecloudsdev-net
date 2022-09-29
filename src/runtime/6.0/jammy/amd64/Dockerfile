ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM amd64/buildpack-deps:jammy-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.10-servicing.22476.5 \
    && curl -fSL --output dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.10-linux-x64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='8a074c93845416f69f035f2d0e16251dd2bd5abcdfcb7863afd59a5ddc78fa03aede8f79b42c7ca857fc19c8dea53d43da4e4a311f35f6f2eaf9fd64afc8f9e4' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.10-jammy-amd64

# .NET Runtime version
ENV DOTNET_VERSION=6.0.10-servicing.22476.5

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
