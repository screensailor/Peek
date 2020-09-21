@_exported import os

@usableFromInline let peek = Logger(subsystem: "peek", category: "🔎")

infix operator ¶ : TernaryPrecedence

@discardableResult public func ¶ <L, R>(lhs: L, rhs: R) -> L {
    peek.debug("\(String(describing:lhs)) \(String(describing: rhs))")
    return lhs
}

extension CustomStringConvertible {
    
    @inlinable
    @discardableResult
    public func peek(
        signpost: StaticString,
        _ type: OSSignpostType,
        id: OSSignpostID = .exclusive,
        dso: UnsafeRawPointer = #dsohandle,
        log: OSLog = .default
    ) -> Self {
        os_signpost(type, dso: dso, log: log, name: signpost, signpostID: id)
        return self
    }
}

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

