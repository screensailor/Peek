public typealias here = CodeLocation

public struct CodeLocation: Codable, Hashable {
    public var function: String
    public var file: String
    public var line: Int
}

extension CodeLocation {
    
    public init(
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) {
        self.function = function
        self.file = file
        self.line = line
    }
}

extension CodeLocation: CustomDebugStringConvertible, CustomStringConvertible {
    
    public var debugDescription: String {
        "\(function) \(file) \(line)"
    }
    
    public var description: String {
        var file = self.file
        if let i = file.lastIndex(of: "/") { // TODO: remove when https://forums.swift.org/t/concise-magic-file-names/31297
            file = file.suffix(from: i).description
        }
        return "\(function) \(file) \(line)"
    }
}

extension CodeLocation {

    public struct Error: Swift.Error, Hashable {
        
        public let message: String
        public let location: CodeLocation
        
        public init(
            _ message: String,
            _ function: String = #function,
            _ file: String = #file,
            _ line: Int = #line
        ) {
            self.message = message
            self.location = .init(function, file, line)
        }
    }
}

extension CodeLocation.Error: CustomStringConvertible {
    
    public var description: String { "\(message) \(location)" }
}
