@_exported import Peek
@_exported import Hope

class Peek™: Hopes {
    
    func test_peek() {
        
        peek()
        peek(as: .error)
        
        5.peek("✅")
        5.peek("✅", as: .fault)
        
        peek(\.name)
        peek(\.name, as: .info)

        2 + 3 ¶ "✅"
        2 + 3 ¶ "✅".here()
        2 + 3 ¶ here()
        
        print( "⚠️".error() )
    }
}
