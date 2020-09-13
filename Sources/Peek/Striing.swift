extension String {

    @inlinable public func here(_ function: String = #function, _ file: String = #file, _ line: Int = #line) -> String {
        "\(self) \(CodeLocation(function, file, line))"
    }
    
    @inlinable public func error(_ function: String = #function, _ file: String = #file, _ line: Int = #line) -> Peek.Error {
        Peek.Error(self, function, file, line)
    }
}

extension Peek {

    public struct Error: Swift.Error, Hashable, CustomStringConvertible {
        public let message: String
        public let function: String
        public let file: String
        public let line: Int
        public var location: CodeLocation { .init(function: function, file: file, line: line) }
        public var description: String { "\(message) \(location)" }
        public init(_ message: String, _ function: String = #function,  _ file: String = #file, _ line: Int = #line) {
            self.message = message
            self.function = function
            self.file = file
            self.line = line
        }
    }
}
