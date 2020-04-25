@discardableResult public func ... <T>(l: T, r: Peek<T>) -> T { r.log(l) }

public struct Peek<A> {
    
    public var message: () -> Any
    public var keyPath: PartialKeyPath<A>
    public var function: StaticString
    public var file: StaticString
    public var line: Int
    
    @inlinable public init(
        _ keyPath: PartialKeyPath<A> = \.self,
        _ function: StaticString = #function,
        _ file: StaticString = #file,
        _ line: Int = #line
    ) {
        self.init("⚠️", keyPath, function, file, line)
    }
    
    public init(
        _ message: @escaping @autoclosure () -> Any,
        _ keyPath: PartialKeyPath<A> = \.self,
        _ function: StaticString = #function,
        _ file: StaticString = #file,
        _ line: Int = #line
    ) {
        self.message = message
        self.keyPath = keyPath
        self.function = function
        self.file = file
        self.line = line
    }

    public func log(_ a: A) -> A {
        print(message(), a[keyPath: keyPath], here(function, file, line))
        return a
    }
}

