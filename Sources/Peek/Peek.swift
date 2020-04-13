import CoreGraphics

public typealias Peekable = CustomDebugStringConvertible

extension Bool: Peekable {}
extension IntegerLiteralType: Peekable {}
extension CGFloat: Peekable {}

extension Peekable where Self: RawRepresentable {
    @inlinable public var debugDescription: String { "\(Self.self).\(rawValue)" }
}

extension Peekable where Self: CustomStringConvertible {
    @inlinable public var debugDescription: String { description }
}

extension Peekable {
    
    @inlinable
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
    
    @inlinable
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
    
    @inlinable
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
    
    @inlinable
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

@inlinable
public func here(
    _ function: String = #function,
    _ file: String = #file,
    _ line: Int = #line,
    at: String = "→"
) -> String {
    "\(at) \(function) \(file.split(separator: "/").last?.description ?? "") \(line)"
}
