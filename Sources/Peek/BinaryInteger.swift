extension CustomDebugStringConvertible where Self: BinaryInteger {
    @inlinable public var debugDescription: String { description }
}

extension Int: CustomDebugStringConvertible {}
extension UInt: CustomDebugStringConvertible {}

