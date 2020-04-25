@inlinable public func here(
    _ function: StaticString = #function,
    _ file: StaticString = #file,
    _ line: Int = #line,
    prefix: String = "→ "
) -> String {
    var file = file.description
    if let i = file.lastIndex(of: "/") {
        file = file.suffix(from: i).description
    }
    return "\(prefix)\(function) \(file) \(line)"
}
