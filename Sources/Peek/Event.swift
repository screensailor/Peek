import Combine
import Foundation

public protocol Event {}
public protocol HotPath {}

public protocol State {
    var context: Context { get }
    init(context: Context)
    func on(_ event: Event) throws
}

public struct Context: Identifiable, Hashable, CustomStringConvertible {
    
    public var id: String { description }
    
    public let name: String
    public let location: CodeLocation
    public let description: String
    
    public init<This: State>(
        named name: String,
        in state: This.Type,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) {
        self.name = name
        self.location = .init(function, file, line)
        self.description = "Context(\(name), at: \(location))"
        Enter<This>().in(self)
    }
}

extension Context {
    public static let states = PassthroughSubject<(State, Context), Never>()
    public static let events = PassthroughSubject<(Event, State, Context), Never>()
    public static let errors = PassthroughSubject<(Event, State, Context, Error), Never>()
}

extension Context {
    
    public var state: State {
        Context.queue.sync {
            Context.state[self]!
        }
    }
}

private extension Context {
    
    static let queue = DispatchQueue(
        label: "lark.event.context.queue",
        qos: .userInitiated
    )
    
    static var state: [Context: State] = [:]
}

extension Event {
    
    @discardableResult
    public func `in`(_ context: Context) -> Context { // TODO: capture code location info
        Thread.onMainThread {
            let state = context.state
            if !(self is HotPath) {
                Context.events.send((self, state, context))
            }
            do {
                try state.on(self)
            } catch {
                Context.errors.send((self, state, context, error))
            }
        }
        return context
    }
}

public struct Enter<This: State>: Event {
    
    public init() {}
    
    @discardableResult
    public func `in`(_ context: Context) -> Context { // TODO: capture code location info
        let state = This.init(context: context)
        Thread.onMainThread {
            Context.events.send((self, state, context))
            Context.queue.sync {
                Context.state[context] = state
            }
            Context.states.send((state, context))
        }
        return context
    }
}

extension Event {
    
    @inlinable
    public func `as`<A: Event>(
        _ type: A.Type,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws -> A {
        guard let o = self as? A else {
            throw "Expected \(A.self) but got \(self)".error(function, file, line)
        }
        return o
    }
    
    @inlinable
    public func notHandled(
        in context: Context,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) -> Error {
        "\(self) not handled in \(context)".error(function, file, line)
    }
}

private extension Thread {
    
    static var onMainThread: (() -> ()) -> () {
        isMainThread ? { $0() } : DispatchQueue.main.sync
    }
}