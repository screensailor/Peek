import Foundation

@discardableResult public func >> <L>(l: L, r: Any) -> L {
    #if DEBUG
    print(l, r)
    #endif
    return l
}

public struct Peek {
    
    public let log: () -> String
    public let date: Date
    public let location: CodeLocation

    public init<A>(
        _ a: A,
        _ keyPath: PartialKeyPath<A>,
        _ message: Any?,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) {
        self.date = Date()
        self.location = here(function, file, line)
        self.log = { [location, date] in
            var o = ""
            print(message ?? "•", a[keyPath: keyPath], location, Peek.format(date), terminator: "", to: &o)
            return o
        }
    }
    
    public static let format: (Date) -> String = {
        if #available(OSX 10.13, *) {
            let f = ISO8601DateFormatter()
            f.formatOptions.formUnion([
                .withFractionalSeconds,
                .withSpaceBetweenDateAndTime
            ])
            return { f.string(from: $0) }
        } else {
            return { $0.description }
        }
    }()
}

extension Peek: CustomStringConvertible, CustomDebugStringConvertible {
    @inlinable public var description: String { log() }
    @inlinable public var debugDescription: String { log() }
}
