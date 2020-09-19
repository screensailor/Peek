import os

@usableFromInline let peek = Logger(subsystem: "peek", category: "🔎")

infix operator ¶ : TernaryPrecedence

@discardableResult public func ¶ <L, R>(lhs: L, rhs: R) -> L
where L: CustomStringConvertible, R: CustomStringConvertible
{
    peek.debug("\(lhs) \(rhs)")
    return lhs
}
//self.location = here(function, file, line)
//self.description = "\(message ?? "•") \(a[keyPath: keyPath]), \(location)"

extension CustomStringConvertible {
    
    @inlinable
    @discardableResult
    public func peek(
        as level: OSLogType = .debug,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) -> Self {
        Peek.peek.log(level: level, "\(self) \(here(function, file, line))")
        return self
    }
    
    @inlinable
    @discardableResult
    public func peek<Message>(
        _ message: @escaping @autoclosure () -> Message,
        as level: OSLogType = .debug,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) -> Self
    where Message: CustomStringConvertible
    {
        Peek.peek.log(level: level, "\(message()) \(self) \(here(function, file, line))")
        return self
    }

    @inlinable
    @discardableResult
    public func peek<Property>(
        _ keyPath: KeyPath<Self, Property>,
        as level: OSLogType = .debug,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) -> Self
    where Property: CustomStringConvertible
    {
        Peek.peek.log(level: level, "\(self[keyPath: keyPath]) \(here(function, file, line))")
        return self
    }

    @inlinable
    @discardableResult
    public func peek<Message, Property>(
        _ message: @escaping @autoclosure () -> Message,
        _ keyPath: KeyPath<Self, Property>,
        as level: OSLogType = .debug,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) -> Self
    where
        Message: CustomStringConvertible,
        Property: CustomStringConvertible
    {
        Peek.peek.log(level: level, "\(message()) \(self[keyPath: keyPath]) \(here(function, file, line))")
        return self
    }
}

