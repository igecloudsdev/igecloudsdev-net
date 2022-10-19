ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-alpine3.16-arm32v7 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rtm.22513.8 \
    && wget -O dotnet.tar.gz https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-7.0.0-linux-musl-arm.tar.gz$SAS_QUERY_STRING \
    && dotnet_sha512='f7c6a655aa3e00b3f71fda2f4ad39536bbebdbf538f1f95e75fac7bbf39c347caba4ec4a8f8752e5165033425024691452c984cfaadf8bb051b3e39be3b42536' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -oxzf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:7.0.0-alpine3.16-arm32v7

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rtm.22513.8

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
