ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM arm64v8/buildpack-deps:jammy-curl AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=6.0.11-servicing.22523.4 \
    && curl -fSL --output dotnet.tar.gz https://dotnetstage.blob.core.windows.net/6-0-403-servicing-22524-2-internal/Runtime/$dotnet_version/dotnet-runtime-6.0.11-linux-arm64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='c889e70ea0b2224eb9163cca6a57cbbbbb8213a551770dc5c9f08d8d49fec1f38ac4802435cc9509baa03970823666fe1dd80621e6ee8592c27b7e639643e5d3' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -oxzf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz

RUN mkdir /dotnet-symlink \
    && ln -s /usr/share/dotnet/dotnet /dotnet-symlink/dotnet


# .NET runtime image
FROM $REPO:6.0.11-jammy-chiseled-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=6.0.11-servicing.22523.4

COPY --from=installer ["/usr/share/dotnet", "/usr/share/dotnet"]
COPY --from=installer ["/dotnet-symlink", "/usr/bin"]

ENTRYPOINT ["/usr/bin/dotnet"]
CMD ["--info"]
