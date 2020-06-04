# Experiment: Producing Smaller Images

This [branch](https://github.com/dotnet/dotnet-docker/tree/feature/r2r-version-bubbles) contains an experimental feature around using Crossgen2 to produce smaller images.  

## Goals

1. **Produce Smaller Images** - Reduce the size of the existing images so that they can be pulled faster and consume less space on disk.
2. **Share Layers Across Images** - Currently the .NET images build upon each other.  The image dependencies look like `runtime-deps` <-- `runtime` <-- `aspnet` <-- `sdk`.  Sharing the layers provides significant benefits in scenarios where multiple .NET images reside on a single machine because you will only have one copy of the share layers on disk.

For additional background reference the primary [issue](https://github.com/dotnet/dotnet-docker/issues/1791) tracking this work.

## Scope

To limit the scope of the experiment the following scoping decisions were made.  Depending on the outcome and success, the scope of the experiment may expand overtime.

1. Alpine - Because the goal is to produce small images.
2. AMD64

## Experiment Variants

1. **Baseline - No Composite Binaries** - These are the current images.  The images variants build on top of each other for maximum layer sharing.

    **Images**
    * `mcr.microsoft.com/dotnet/nightly/runtime:5.0-alpine-no-composite` [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/runtime/alpine3.11/amd64/no-composite/Dockerfile)
    * `mcr.microsoft.com/dotnet/nightly/aspnet:5.0-alpine-no-composite` [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/aspnet/alpine3.11/amd64/no-composite/Dockerfile)
    * `mcr.microsoft.com/dotnet/nightly/sdk:5.0-alpine-no-composite` [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/sdk/alpine3.11/amd64/no-composite/Dockerfile)

1. **Composite .NET Runtime** - With this option, the .NET runtime is crossgen'd to produce a composite ready to run binary within the `runtime` image.  The `aspnet` and `sdk` images build on top of the `runtime` image but their binaries are not crossgen'd.

    **Images**
    * `mcr.microsoft.com/dotnet/nightly/runtime:5.0-alpine-composite` [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/runtime/alpine3.11/amd64/composite/Dockerfile)
    * `mcr.microsoft.com/dotnet/nightly/aspnet:5.0-alpine-runtime-composite` [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/aspnet/alpine3.11/amd64/runtime-composite/Dockerfile)
    * `mcr.microsoft.com/dotnet/nightly/sdk:5.0-alpine-runtime-composite` [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/sdk/alpine3.11/amd64/runtime-composite/Dockerfile)

    **Pros**
    1. Maintains shared layers across the .NET images.
    1. Simple implementation with a hopefully noticeable size reduction.

    **Cons**
    1. The `aspnet` image is not as small as it could be with other approaches.

1. **Composite .NET Runtime + Composite ASP.NET Core** - This option starts with the Composite .NET Runtime.  The difference is in the `aspnet` image, both the .NET and ASP.NET runtimes are crossgen'd to produce a single composite ready to run binary.  Because of this, the `aspnet` image is based on the `runtime-deps` image.  Basing it on the `runtime` image would be nonsensical and produce a bloated image.  The SDK image is built on top of the ASP.NET image but does not contain additional crossgen'd binaries.

    **Images**
    * `mcr.microsoft.com/dotnet/nightly/runtime:5.0-alpine-composite` [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/runtime/alpine3.11/amd64/composite/Dockerfile)
    * `mcr.microsoft.com/dotnet/nightly/aspnet:5.0-alpine-composite` [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/aspnet/alpine3.11/amd64/composite/Dockerfile)
    * `mcr.microsoft.com/dotnet/nightly/sdk:5.0-alpine-aspnet-composite` [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/sdk/alpine3.11/amd64/aspnet-composite/Dockerfile)

    **Pros**
    1. Produces the smallest `aspnet` image of the mentioned options.

    **Cons**
    1. The `runtime` image layers cannot be shared.  This is a disadvantage in scenarios where both the `runtime` and `aspnet` images are used within the same environment.

1. **Composite .NET Runtime + Composed Composite ASP.NET Core** - This option starts with the Composite .NET Runtime.  The difference is in the `aspnet` image, the ASP.NET runtime is crossgen'd by itself to produce a single composite ready to run binary.  In this scenario there are two composite ready to run binaries in the `aspnet` image layers.  The SDK image is build on top of the ASP.NET image but does not add any addition crossgen'd binaries.

    **Images**
    * `mcr.microsoft.com/dotnet/nightly/runtime:5.0-alpine-composite` [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/runtime/alpine3.11/amd64/composite/Dockerfile)
    * `mcr.microsoft.com/dotnet/nightly/aspnet:5.0-alpine-composed-composite` [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/aspnet/alpine3.11/amd64/composed-composite/Dockerfile)
    * `mcr.microsoft.com/dotnet/nightly/sdk:5.0-alpine-aspnet-composed-composite` [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/sdk/alpine3.11/amd64/aspnet-composed-composite/Dockerfile)

    **Pros**
    1. Maintains shared layers across the .NET images.
    1. Produces a smaller `aspnet` image than the single Composite .NET Runtime approach.

    **Cons**
    1. The `aspnet` image is not as small as it could be with other approaches.

1. **Composite self-contained apps** - With this option, the app is published as self-contained and a single composite ready to run binary is produced for the app and runtime.

    **Pros**
    1. Produces a smallest possible image for a given app.
    1. Can be used in addition to choosing one of the above options for the .NET images.  This would be recommended for scenarios where size is critical.

    **Cons**
    1. Using self-contained deployments put the servicing burden completely on the app developer.

## Building Images

The experimental images are currently not pushed to a registry and must be built locally by running the following command.

```console
dotnet-docker> .\build-and-test.ps1 -Version 5.0 -OS alpine3.11
```
