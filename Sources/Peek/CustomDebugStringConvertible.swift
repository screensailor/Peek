extension CustomDebugStringConvertible {
    
    @inlinable
    @discardableResult
    public func peek(
        _ function: StaticString = #function,
        _ file: StaticString = #file,
        _ line: Int = #line
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
        _ function: StaticString = #function,
        _ file: StaticString = #file,
        _ line: Int = #line
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
        _ function: StaticString = #function,
        _ file: StaticString = #file,
        _ line: Int = #line
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
        _ function: StaticString = #function,
        _ file: StaticString = #file,
        _ line: Int = #line
    ) -> Self {
        #if DEBUG
        print("\(message())", self[keyPath: keyPath], here(function, file, line))
        #endif
        return self
    }
}

