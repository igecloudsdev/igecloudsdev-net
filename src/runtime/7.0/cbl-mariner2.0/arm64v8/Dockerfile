ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM $REPO:7.0.0-rc.2-cbl-mariner2.0-arm64v8 AS installer

ARG SAS_QUERY_STRING

# Retrieve .NET Runtime
RUN dotnet_version=7.0.0-rc.2.22472.3 \
    && curl -fSL --output dotnet-host.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-host-$dotnet_version-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='ef7bccbdf4ee4cf28a162398f43ea586df2467b12a2cc75fc23b3a0226b1b4aefb1c37a27064728e5e8fd73b99372f4359a81c6ad7d22a28e57c6b05ed1e8465' \
    && echo "$dotnet_sha512  dotnet-host.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-hostfxr.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-hostfxr-$dotnet_version-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='c6986237e87e1b40efc808491b681e2fb72167f9ac407462ee8bdec37b296c1f20baa251fa8db595a07ccfbe1d498d2304a770f7c55263caf0cb3b25ea88a9f6' \
    && echo "$dotnet_sha512  dotnet-hostfxr.rpm" | sha512sum -c - \
    \
    && curl -fSL --output dotnet-runtime.rpm https://dotnetbuilds.blob.core.windows.net/internal/Runtime/$dotnet_version/dotnet-runtime-$dotnet_version-aarch64.rpm$SAS_QUERY_STRING \
    && dotnet_sha512='b2ae66ef388818e417df5d3bf3b0e833b05a6445e63b187ebce91b77cea1260c755256c139ca959d256c72a82a079cb756184d23183482e6ede3b5233d23435f' \
    && echo "$dotnet_sha512  dotnet-runtime.rpm" | sha512sum -c -


# .NET runtime image
FROM $REPO:7.0.0-rc.2-cbl-mariner2.0-arm64v8

# .NET Runtime version
ENV DOTNET_VERSION=7.0.0-rc.2.22472.3

COPY --from=installer /dotnet-host.rpm /dotnet-host.rpm
COPY --from=installer /dotnet-hostfxr.rpm /dotnet-hostfxr.rpm
COPY --from=installer /dotnet-runtime.rpm /dotnet-runtime.rpm

RUN tdnf install -y --disablerepo=* dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm \
    && rm dotnet-host.rpm dotnet-hostfxr.rpm dotnet-runtime.rpm
