ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.9-alpine3.16-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.9-servicing.22419.5 \
    && wget -O dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.9-linux-musl-x64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='e3eb4804dddbc34be37e3d984c13a668605ef7eea6b2daca95ea3fa7ca51b2fe4845df1ad0d343de9075796bf0d4474d7e14e5b3b4b515005d0e24ec53237ad3' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.9-alpine3.16-amd64

# .NET Runtime version
ENV DOTNET_VERSION=6.0.9-servicing.22419.5

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
