import wapc

@_cdecl("__guest_call")
func __guest_call(operation_size: UInt, payload_size: UInt) -> Bool {
    return wapc.handleCall(operation_size: operation_size, payload_size: payload_size)
}

func hello(payload: String) -> String {
    return "the hello function received: '\(payload)'"
}

func validate(payload: String) -> String {
    let hostMsg = wapc.hostCall(
        binding: "binding_name",
        namespace: "namespace_name",
        operation: "operation_name",
        payload: "that's the payload"
    )

    if hostMsg == nil {
        return "the validate function called the host but something went wrong"
    }
    return "the validate function called the host and received back: '\(hostMsg!)'"
}


wapc.registerFunction(name: "hello", fn: hello)
wapc.registerFunction(name: "validate", fn: validate)