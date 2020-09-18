extension CodeLocation {

    public struct Error: Swift.Error, Hashable {
        
        public let message: String
        public let location: CodeLocation
        
        public init(
            _ message: Any,
            _ function: String = #function,
            _ file: String = #file,
            _ line: Int = #line
        ) {
            self.message = String(describing: message)
            self.location = .init(function, file, line)
        }
    }
}

extension CodeLocation.Error: CustomStringConvertible {
    
    public var description: String { "\(message) \(location)" }
}
