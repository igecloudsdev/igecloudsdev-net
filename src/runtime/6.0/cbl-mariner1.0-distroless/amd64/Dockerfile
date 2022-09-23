ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM mcr.microsoft.com/cbl-mariner/base/core:1.0 AS installer

ARG SAS_QUERY_STRING

RUN tdnf install -y \
        ca-certificates-microsoft \
    && tdnf clean all

# Retrieve .NET Runtime
RUN dotnet_version=6.0.10-servicing.22469.10 \
    && curl -fSL --output dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-6.0.10-linux-x64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='4dbca555fd41f58190daf672058294806b0d5cb19635eaf2f933b85e94a25c307e0ea6da23cb2244bb2817adf9717e9697e21d2aea80481acaa5c3cc77e4ec2c' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -oxzf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz

RUN mkdir /dotnet-symlink \
    && ln -s /usr/share/dotnet/dotnet /dotnet-symlink/dotnet


# .NET runtime image
FROM $REPO:6.0.10-cbl-mariner1.0-distroless-amd64

# .NET Runtime version
ENV DOTNET_VERSION=6.0.10-servicing.22469.10

COPY --from=installer ["/usr/share/dotnet", "/usr/share/dotnet"]
COPY --from=installer ["/dotnet-symlink", "/usr/bin"]
