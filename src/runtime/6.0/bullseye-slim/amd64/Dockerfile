ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM amd64/buildpack-deps:bullseye-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.11-servicing.22523.4 \
    && curl -fSL --output dotnet.tar.gz https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22524-2-internal/Runtime/$dotnet_version/dotnet-runtime-6.0.11-linux-x64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='9462d73fd3f72efaa2fb4aa472055f388da4915e75cfc123298b3494f1dfd8d48c44bfa6cd5c41678ab7353d9085d05dd7f1fee0eef20c11742446e3591e45df' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:6.0.11-bullseye-slim-amd64

# .NET Runtime version
ENV DOTNET_VERSION=6.0.11-servicing.22523.4

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
