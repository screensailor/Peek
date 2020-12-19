extension Optional: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .none: return "\(Wrapped.self)?.none"
        case .some(let o): return String(describing: o)
        }
    }
}
