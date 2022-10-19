ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM arm64v8/buildpack-deps:bullseye-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rtm.22513.8 \
    && curl -fSL --output dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-7.0.0-linux-arm64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='9817380e43aa30d77be9734f482e152f7eacdcbb876bedbd662e751d0377a236c101c8d4213956b9eb4693bd6bebe31cd5dddb831484a45f7c54b817ec0ba5bf' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:7.0.0-bullseye-slim-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rtm.22513.8

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
