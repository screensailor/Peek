import Combine
import Foundation

public protocol Event {}

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
    
    public init<InitialState: State>(
        named name: String,
        in state: InitialState.Type,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) {
        self.name = name
        self.location = .init(function, file, line)
        self.description = "Context(\(name), at: \(location))"
        Enter<InitialState>().in(self)
    }
}

extension Context {
    public static let states = PassthroughSubject<(state: State, context: Context), Never>()
    public static let events = PassthroughSubject<(event: Event, state: State, context: Context), Never>()
    public static let errors = PassthroughSubject<(event: Event, state: State, context: Context, error: Error), Never>()
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
    public func `in`(_ context: Context) -> Self { // TODO: capture code location info
        Thread.onMainThread {
            let state = context.state
            do {
                try state.on(self)
                Context.events.send((self, state, context))
            } catch {
                Context.errors.send((self, state, context, error))
            }
        }
        return self
    }
}

public struct WillExit<This: State>: Event {}
public struct DidExit<This: State>: Event {}

private extension State {
    func willExit() { WillExit<Self>().in(context) }
    func didExit() { DidExit<Self>().in(context) }
}

public struct Enter<This: State>: Event {
    
    public init() {}
    
    @discardableResult
    public func `in`(_ context: Context) -> This { // TODO: capture code location info
        let state = This.init(context: context)
        Thread.onMainThread {
            let old = Context.queue.sync { Context.state[context] }
            old?.willExit()
            Context.queue.sync {
                Context.state[context] = state
            }
            Context.states.send((state, context))
            (self as Event).in(context)
            old?.didExit()
        }
        return state
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

extension PassthroughSubject
where
    Output == (state: State, context: Context),
    Failure == Never
{
    
    public subscript<S: State>(_: S.Type) -> AnyPublisher<(state: S, context: Context), Never> {
        compactMap{ o in (o.state as? S).map{ s in (s, o.context) } }.eraseToAnyPublisher()
    }
}

extension PassthroughSubject
where
    Output == (event: Event, state: State, context: Context),
    Failure == Never
{
    
    public subscript<E: Event>(_: E.Type) -> AnyPublisher<(event: E, state: State, context: Context), Never> {
        compactMap{ o in (o.event as? E).map{ e in (e, o.state, o.context) } }.eraseToAnyPublisher()
    }
    
    public subscript<E: Event, S: State>(_: E.Type, _: S.Type) -> AnyPublisher<(event: E, state: S, context: Context), Never> {
        compactMap{ o in
            guard let e = o.event as? E, let s = o.state as? S else { return nil }
            return (e, s, o.context)
        }.eraseToAnyPublisher()
    }
}

extension PassthroughSubject
where
    Output == (event: Event, state: State, context: Context, error: Error),
    Failure == Never
{
    
    public subscript<E: Event>(_: E.Type) -> AnyPublisher<(event: E, state: State, context: Context, error: Error), Never> {
        compactMap{ o in (o.event as? E).map{ e in (e, o.state, o.context, o.error) } }.eraseToAnyPublisher()
    }
    
    public subscript<E: Event, S: State>(_: E.Type, _: S.Type) -> AnyPublisher<(event: E, state: S, context: Context, error: Error), Never> {
        compactMap{ o in
            guard let e = o.event as? E, let s = o.state as? S else { return nil }
            return (e, s, o.context, o.error)
        }.eraseToAnyPublisher()
    }
}
