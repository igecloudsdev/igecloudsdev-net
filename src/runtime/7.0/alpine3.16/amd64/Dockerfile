ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-alpine3.16-amd64 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rtm.22518.5 \
    && wget -O dotnet.tar.gz https://dotnetstage.blob.core.windows.net/7-0-100-rtm-22519-28-internal/Runtime/$dotnet_version/dotnet-runtime-7.0.0-linux-musl-x64.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='f37774eee98f38d9849c79d05c58b0d9e733d480b31a0615a1039613662579efef392d0129b2582281861c0647bacdb3acd78213bd33869b698e529b8e78ccee' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:7.0.0-alpine3.16-amd64

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rtm.22518.5

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
