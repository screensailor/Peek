extension Optional { // avoiding CustomStringConvertible conformance
    
    @inlinable
    @discardableResult
    public func peek(
        as level: OSLogType = .debug,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) -> Self {
        logger.log(level: level, "\(String(describing: self)) \(here(function, file, line))")
        return self
    }
    
    @inlinable
    @discardableResult
    public func peek<Message>(
        _ message: @escaping @autoclosure () -> Message,
        as level: OSLogType = .debug,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) -> Self
    where Message: CustomStringConvertible
    {
        logger.log(level: level, "\(message()) \(String(describing: self)) \(here(function, file, line))")
        return self
    }

    @inlinable
    @discardableResult
    public func peek<Property>(
        _ keyPath: KeyPath<Self, Property>,
        as level: OSLogType = .debug,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) -> Self
    where Property: CustomStringConvertible
    {
        logger.log(level: level, "\(self[keyPath: keyPath]) \(here(function, file, line))")
        return self
    }

    @inlinable
    @discardableResult
    public func peek<Message, Property>(
        _ message: @escaping @autoclosure () -> Message,
        _ keyPath: KeyPath<Self, Property>,
        as level: OSLogType = .debug,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) -> Self
    where
        Message: CustomStringConvertible,
        Property: CustomStringConvertible
    {
        logger.log(level: level, "\(message()) \(self[keyPath: keyPath]) \(here(function, file, line))")
        return self
    }
}
