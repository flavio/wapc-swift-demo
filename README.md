# wapc-swift-demo

This project shows how to write a simple Wasm module in Swift that
leverages the [waPC](https://github.com/wapc) protocol via the
[wapc-guest-swift](https://github.com/flavio/wapc-guest-swift) SDK.

# Building

Ensure you have the [Swiftwasm](https://swiftwasm.org/) compiler installed.

Building the project can be done using SwiftPM:

```shell
$ swift build --triple wasm32-unknown-wasi -c release
```

If you have either podman or docker installed on your machine, this can be done
with:

```shell
$ make containerized-release
```
