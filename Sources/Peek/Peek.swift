import Foundation

public typealias Peekable = CustomDebugStringConvertible

extension Peekable where Self: RawRepresentable {
    public var debugDescription: String { "\(Self.self).\(rawValue)" }
}

extension Peekable where Self: CustomStringConvertible {
    public var debugDescription: String { description }
}

extension Bool: Peekable {}
extension IntegerLiteralType: Peekable {}
extension CGFloat: Peekable {}

extension Peekable {
    
    @discardableResult
    public func peek(
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) -> Self {
        #if DEBUG
        print(self, here(function, file, line))
        #endif
        return self
    }
    
    @discardableResult
    public func peek<Message>(
        _ message: @autoclosure () -> Message,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) -> Self {
        #if DEBUG
        print("\(message())", self, here(function, file, line))
        #endif
        return self
    }
    
    @discardableResult
    public func poke<Property>(
        _ keyPath: KeyPath<Self, Property>,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) -> Self {
        #if DEBUG
        print(self[keyPath: keyPath], here(function, file, line))
        #endif
        return self
    }
    
    @discardableResult
    public func poke<Message, Property>(
        _ message: @autoclosure () -> Message,
        _ keyPath: KeyPath<Self, Property>,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) -> Self {
        #if DEBUG
        print("\(message())", self[keyPath: keyPath], here(function, file, line))
        #endif
        return self
    }
}

public func here(
    _ function: String = #function,
    _ file: String = #file,
    _ line: Int = #line,
    at: String = "→"
) -> String {
    "\(at) \(function) \(file.name) \(line)"
}

private extension String {
    var name: String {
        split(separator: "/").last?.description ?? ""
    }
}
