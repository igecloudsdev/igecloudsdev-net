# Experiment Using CrossGen2 to Produce Smaller Images

This [branch](https://github.com/dotnet/dotnet-docker/tree/feature/r2r-version-bubbles) contains a set of experiments around using Crossgen2 to produce smaller images.  For additional background reference the primary [issue](https://github.com/dotnet/dotnet-docker/issues/1791) tracking this work.

Because the goal is to produce small images, the experiment focuses only on Alpine images.  Another scoping decision is to only amd64.  Depending on the outcome and success, the scope of the experiment may expand overtime.

## Experiments

1. Composite .NET Runtime - With this option, the .NET runtime is crossgen'd to produce a composite ready to run binary within the `runtime` image.  The `aspnet` and `sdk` images build on top of the `runtime` image but their binaries are not crossgen'd.

    **Dockerfiles**
    * [runtime](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/runtime/alpine3.11/amd64/composite/Dockerfile)
    * [aspnet](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/aspnet/alpine3.11/amd64/runtime-composite/Dockerfile)
    * [sdk](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/sdk/alpine3.11/amd64/runtime-composite/Dockerfile)

    **Pros**
    1. Maintains shared layers across the .NET images.
    1. Simple implementation with a hopefully noticeable size reduction.

    **Cons**
    1. The `aspnet` image is not as small as it could be with other approaches.

1. Composite .NET Runtime + Composite ASP.NET Core - This option starts with the Composite .NET Runtime.  The difference is in the `aspnet` image, both the .NET and ASP.NET runtimes are crossgen'd to produce a single composite ready to run binary.  Because of this, the `aspnet` image is based on the `runtime-deps` image.  Basing it on the `runtime` image would be nonsensical and produce a bloated image.  The SDK image is built on top of the ASP.NET image but does not contain additional crossgen'd binaries.

    **Dockerfiles**
    * [runtime](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/runtime/alpine3.11/amd64/composite/Dockerfile)
    * [aspnet](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/aspnet/alpine3.11/amd64/composite/Dockerfile)
    * [sdk](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/sdk/alpine3.11/amd64/aspnet-composite/Dockerfile)

    **Pros**
    1. Produces the smallest `aspnet` image of the mentioned options.

    **Cons**
    1. The `runtime` image layers cannot be shared.  This is a disadvantage in scenarios where both the `runtime` and `aspnet` images are used within the same environment.

1. Composite .NET Runtime + Composed Composite ASP.NET Core - This option starts with the Composite .NET Runtime.  The difference is in the `aspnet` image, the ASP.NET runtime is crossgen'd by itself to produce a single composite ready to run binary.  In this scenario there are two composite ready to run binaries in the `aspnet` image layers.  The SDK image is build on top of the ASP.NET image but does not add any addition crossgen'd binaries.

    **Dockerfiles**
    * [runtime](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/runtime/alpine3.11/amd64/composite/Dockerfile)
    * [aspnet](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/aspnet/alpine3.11/amd64/composed-composite/Dockerfile)
    * [sdk](https://github.com/dotnet/dotnet-docker/blob/feature/r2r-version-bubbles/5.0/sdk/alpine3.11/amd64/aspnet-composed-composite/Dockerfile)

    **Pros**
    1. Maintains shared layers across the .NET images.
    1. Produces a smaller `aspnet` image than the single Composite .NET Runtime approach.

    **Cons**
    1. The `aspnet` image is not as small as it could be with other approaches.

## Building Images

To build the images locally run the following command.

```console
dotnet-docker> .\build-and-test.ps1 -Version 5.0 -OS alpine3.11
```
