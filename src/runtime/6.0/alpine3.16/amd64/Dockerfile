ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:6.0.10-alpine3.16-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.10-servicing.22476.5 \
    && wget -O dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.10-linux-musl-x64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='0277e5f81ee0b28b262ee4b0de5e62d4599acf95f65dba12a562ad682675e9aa9d1d4fb5b6d3a49bac481afc405fa2596a48407ba5225093e5d6effd69aa0105' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.10-alpine3.16-amd64

# .NET Runtime version
ENV DOTNET_VERSION=6.0.10-servicing.22476.5

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
