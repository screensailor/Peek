import Foundation

infix operator ¶ : TernaryPrecedence

@discardableResult public func ¶ <L, R>(lhs: L, rhs: R) -> L {
    #if DEBUG
    print(rhs, lhs)
    #endif
    return lhs
}

public struct Peek {
    
    public let log: () -> String
    public let location: CodeLocation

    public init<A>(
        _ a: A,
        _ keyPath: PartialKeyPath<A>,
        _ message: Any?,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) {
        self.location = here(function, file, line)
        self.log = { [location] in
            var o = ""
            print(message ?? "•", a[keyPath: keyPath], location, terminator: "", to: &o)
            return o
        }
    }
}

extension Peek: CustomStringConvertible, CustomDebugStringConvertible {
    @inlinable public var description: String { log() }
    @inlinable public var debugDescription: String { log() }
}
