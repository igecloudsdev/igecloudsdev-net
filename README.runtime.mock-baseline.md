# Featured Tags

* `3.1` (LTS)
  * `docker pull mcr.microsoft.com/dotnet/runtime:3.1`
* `5.0` (Current)
  * `docker pull mcr.microsoft.com/dotnet/runtime:5.0`

# About This Image

This image contains the .NET Core runtimes and libraries and is optimized for running .NET Core apps in production. This repository is limited to .NET Core 2.1 and 3.1. For .NET 5.0 and higher, see [dotnet/nightly/runtime](https://hub.docker.com/_/microsoft-dotnet-nightly-runtime/) for those versions.

Watch [dotnet/announcements](https://github.com/dotnet/announcements/labels/Docker) for Docker-related .NET announcements.

# How to Use the Image

The [.NET Core Docker samples](https://github.com/dotnet/dotnet-docker/blob/master/samples/README.md) show various ways to use .NET Core and Docker together. See [Building Docker Images for .NET Core Applications](https://docs.microsoft.com/dotnet/core/docker/building-net-docker-images) to learn more.

## Container sample: Run a simple application

You can quickly run a container with a pre-built [.NET Core Docker image](https://hub.docker.com/_/microsoft-dotnet-core-samples/), based on the [.NET Core console sample](https://github.com/dotnet/dotnet-docker/blob/master/samples/dotnetapp/README.md).

Type the following command to run a sample console application:

```console
docker run --rm mcr.microsoft.com/dotnet/core/samples
```

# Related Repos

.NET:

* [dotnet](https://hub.docker.com/_/microsoft-dotnet/): .NETore
* [dotnet/sdk](https://hub.docker.com/_/microsoft-dotnet-sdk/): .NET SDK
* [dotnet/aspnet](https://hub.docker.com/_/microsoft-dotnet-aspnet/): ASP.NET Runtime
* [dotnet/runtime-deps](https://hub.docker.com/_/microsoft-dotnet-runtime-deps/): .NET Runtime Dependencies
* [dotnet/samples](https://hub.docker.com/_/microsoft-dotnet-samples/): .NET Samples
* [dotnet/nightly](https://hub.docker.com/_/microsoft-dotnet-nightly/): .NET (Preview)

.NET Framework:

* [dotnet/framework](https://hub.docker.com/_/microsoft-dotnet-framework/): .NET Framework, ASP.NET and WCF
* [dotnet/framework/samples](https://hub.docker.com/_/microsoft-dotnet-framework-samples/): .NET Framework, ASP.NET and WCF Samples

# Full Tag Listing

## Linux amd64 Tags
Tags | Dockerfile | OS Version | Last Modified
-----------| -------------| -------------| -------------
5.0.0-buster-slim-amd64, 5.0-buster-slim-amd64, 5.0.0-buster-slim, 5.0-buster-slim, 5.0.0, 5.0, latest | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/5.0/buster-slim/amd64/Dockerfile) | Debian 10 | 08/20/2020
5.0.0-alpine3.12-amd64, 5.0-alpine3.12-amd64, 5.0.0-alpine3.12, 5.0-alpine3.12, 5.0-alpine | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/5.0/alpine3.12/amd64/Dockerfile) | Alpine 3.12 | 08/20/2020
5.0.0-focal-amd64, 5.0-focal-amd64, 5.0.0-focal, 5.0-focal | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/5.0/focal/amd64/Dockerfile) | Ubuntu 20.04 | 08/20/2020
3.1.7-buster-slim, 3.1-buster-slim, 3.1.7, 3.1 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/3.1/buster-slim/amd64/Dockerfile) | Debian 10 | 08/20/2020
3.1.7-alpine3.12, 3.1-alpine3.12, 3.1-alpine | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/3.1/alpine3.12/amd64/Dockerfile) | Alpine 3.12 | 08/20/2020
3.1.7-focal, 3.1-focal | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/3.1/focal/amd64/Dockerfile) | Ubuntu 20.04 | 08/20/2020
3.1.7-bionic, 3.1-bionic | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/3.1/bionic/amd64/Dockerfile) | Ubuntu 18.04 | 08/20/2020
2.1.21-stretch-slim, 2.1-stretch-slim, 2.1.21, 2.1 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/2.1/stretch-slim/amd64/Dockerfile) | Debian 9 | 08/20/2020
2.1.21-alpine3.12, 2.1-alpine3.12, 2.1-alpine | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/2.1/alpine3.12/amd64/Dockerfile) | Alpine 3.12 | 08/20/2020
2.1.21-focal, 2.1-focal | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/2.1/focal/amd64/Dockerfile) | Ubuntu 20.04 | 08/20/2020
2.1.21-bionic, 2.1-bionic | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/2.1/bionic/amd64/Dockerfile) | Ubuntu 18.04 | 08/20/2020

## Linux arm64 Tags
Tags | Dockerfile | OS Version | Last Modified
-----------| -------------| -------------| -------------
5.0.0-buster-slim-arm64v8, 5.0-buster-slim-arm64v8, 5.0.0, 5.0, latest | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/5.0/buster-slim/arm64v8/Dockerfile) | Debian 10 | 08/20/2020
5.0.0-alpine3.12-arm64v8, 5.0-alpine3.12-arm64v8, 5.0-alpine-arm64v8 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/5.0/alpine3.12/arm64v8/Dockerfile) | Alpine 3.12 | 08/20/2020
5.0.0-focal-arm64v8, 5.0-focal-arm64v8 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/5.0/focal/arm64v8/Dockerfile) | Ubuntu 20.04 | 08/20/2020
3.1.7-buster-slim-arm64v8, 3.1-buster-slim-arm64v8, 3.1.7, 3.1 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/3.1/buster-slim/arm64v8/Dockerfile) | Debian 10 | 08/20/2020
3.1.7-alpine3.12-arm64v8, 3.1-alpine3.12-arm64v8, 3.1-alpine-arm64v8 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/3.1/alpine3.12/arm64v8/Dockerfile) | Alpine 3.12 | 08/20/2020
3.1.7-focal-arm64v8, 3.1-focal-arm64v8 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/3.1/focal/arm64v8/Dockerfile) | Ubuntu 20.04 | 08/20/2020
3.1.7-bionic-arm64v8, 3.1-bionic-arm64v8 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/3.1/bionic/arm64v8/Dockerfile) | Ubuntu 18.04 | 08/20/2020

## Linux arm32 Tags
Tags | Dockerfile | OS Version | Last Modified
-----------| -------------| -------------| -------------
5.0.0-buster-slim-arm32v7, 5.0-buster-slim-arm32v7, 5.0.0, 5.0, latest | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/5.0/buster-slim/arm32v7/Dockerfile) | Debian 10 | 08/20/2020
5.0.0-focal-arm32v7, 5.0-focal-arm32v7 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/5.0/focal/arm32v7/Dockerfile) | Ubuntu 20.04 | 08/20/2020
3.1.7-buster-slim-arm32v7, 3.1-buster-slim-arm32v7, 3.1.7, 3.1 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/3.1/buster-slim/arm32v7/Dockerfile) | Debian 10 | 08/20/2020
3.1.7-focal-arm32v7, 3.1-focal-arm32v7 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/3.1/focal/arm32v7/Dockerfile) | Ubuntu 20.04 | 08/20/2020
3.1.7-bionic-arm32v7, 3.1-bionic-arm32v7 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/3.1/bionic/arm32v7/Dockerfile) | Ubuntu 18.04 | 08/20/2020
2.1.21-stretch-slim-arm32v7, 2.1-stretch-slim-arm32v7, 2.1.21, 2.1 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/2.1/stretch-slim/arm32v7/Dockerfile) | Debian 9 | 08/20/2020
2.1.21-focal-arm32v7, 2.1-focal-arm32v7 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/2.1/focal/arm32v7/Dockerfile) | Ubuntu 20.04 | 08/20/2020
2.1.21-bionic-arm32v7, 2.1-bionic-arm32v7 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/2.1/bionic/arm32v7/Dockerfile) | Ubuntu 18.04 | 08/20/2020

## Windows Server, version 2004 amd64 Tags
Tag | Dockerfile | Last Modified
---------| ---------------| -------------
5.0.0-nanoserver-2004, 5.0-nanoserver-2004, 5.0.0, 5.0, latest | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/5.0/nanoserver-2004/amd64/Dockerfile) | 08/20/2020
3.1.7-nanoserver-2004, 3.1-nanoserver-2004, 3.1.7, 3.1 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/3.1/nanoserver-2004/amd64/Dockerfile) | 08/20/2020
2.1.21-nanoserver-2004, 2.1-nanoserver-2004, 2.1.21, 2.1 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/2.1/nanoserver-2004/amd64/Dockerfile) | 08/20/2020

## Windows Server, version 1909 amd64 Tags
Tag | Dockerfile | Last Modified
---------| ---------------| -------------
5.0.0-nanoserver-1909, 5.0-nanoserver-1909, 5.0.0, 5.0, latest | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/5.0/nanoserver-1909/amd64/Dockerfile) | 08/20/2020
3.1.7-nanoserver-1909, 3.1-nanoserver-1909, 3.1.7, 3.1 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/3.1/nanoserver-1909/amd64/Dockerfile) | 08/20/2020
2.1.21-nanoserver-1909, 2.1-nanoserver-1909, 2.1.21, 2.1 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/2.1/nanoserver-1909/amd64/Dockerfile) | 08/20/2020

## Windows Server, version 1903 amd64 Tags
Tag | Dockerfile | Last Modified
---------| ---------------| -------------
5.0.0-nanoserver-1903, 5.0-nanoserver-1903, 5.0.0, 5.0, latest | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/5.0/nanoserver-1903/amd64/Dockerfile) | 08/20/2020
3.1.7-nanoserver-1903, 3.1-nanoserver-1903, 3.1.7, 3.1 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/3.1/nanoserver-1903/amd64/Dockerfile) | 08/20/2020
2.1.21-nanoserver-1903, 2.1-nanoserver-1903, 2.1.21, 2.1 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/2.1/nanoserver-1903/amd64/Dockerfile) | 08/20/2020

## Windows Server 2019 amd64 Tags
Tag | Dockerfile | Last Modified
---------| ---------------| -------------
5.0.0-nanoserver-1809, 5.0-nanoserver-1809, 5.0.0, 5.0, latest | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/5.0/nanoserver-1809/amd64/Dockerfile) | 08/20/2020
5.0.0-windowsservercore-ltsc2019, 5.0-windowsservercore-ltsc2019 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/5.0/windowsservercore-ltsc2019/amd64/Dockerfile) | 08/20/2020
3.1.7-nanoserver-1809, 3.1-nanoserver-1809, 3.1.7, 3.1 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/3.1/nanoserver-1809/amd64/Dockerfile) | 08/20/2020
2.1.21-nanoserver-1809, 2.1-nanoserver-1809, 2.1.21, 2.1 | [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/runtime/2.1/nanoserver-1809/amd64/Dockerfile) | 08/20/2020

You can retrieve a list of all available tags for dotnet/core/runtime at https://mcr.microsoft.com/v2/dotnet/core/runtime/tags/list.

# Support

See [Microsoft Support for .NET Core](https://github.com/dotnet/core/blob/master/microsoft-support.md) for the support lifecycle.

# Image Update Policy

* We update the supported .NET Core images within 12 hours of any updates to their base images (e.g. debian:buster-slim, windows/nanoserver:1909, buildpack-deps:bionic-scm, etc.).
* We publish .NET Core images as part of releasing new versions of .NET Core including major/minor and servicing.

# Feedback

* [File an issue](https://github.com/dotnet/dotnet-docker/issues/new/choose)
* [Contact Microsoft Support](https://support.microsoft.com/contactus/)

# License

* Legal Notice: [Container License Information](https://aka.ms/mcr/osslegalnotice)
* [.NET Core license](https://github.com/dotnet/dotnet-docker/blob/master/LICENSE)
* [Discover licensing for Linux image contents](https://github.com/dotnet/dotnet-docker/blob/master/documentation/image-artifact-details.md)
* [Windows Nano Server license](https://hub.docker.com/_/microsoft-windows-nanoserver/) (only applies to Windows containers)
* [Pricing and licensing for Windows Server 2019](https://www.microsoft.com/cloud-platform/windows-server-pricing)
