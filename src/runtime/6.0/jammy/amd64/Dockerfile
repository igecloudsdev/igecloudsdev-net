ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM amd64/buildpack-deps:jammy-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.11-servicing.22518.9 \
    && curl -fSL --output dotnet.tar.gz https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22519-42-internal/Runtime/$dotnet_version/dotnet-runtime-6.0.11-linux-x64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='887c87a2b3a131e27ac50f8cd295f970d548b307974803c3be90db5692d04100f4ccc78d757f10d2f6dd3208ad1ff40af7c4e6c7d3b3790312c4d59e46db68e4' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.11-jammy-amd64

# .NET Runtime version
ENV DOTNET_VERSION=6.0.11-servicing.22518.9

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
