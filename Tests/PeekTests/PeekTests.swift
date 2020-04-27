import XCTest
@testable import Peek

class PeekTests: XCTestCase {
    
    func test_peek() {
        peek()
        5.peek("✅")
        peek(\.className)
        peek("✅", \.className){ print("❗️log", $0.log()) }
        2 + 3 ... "✅"
        2 + 3 ... "✅".here()
        print( "⚠️".error() )
        2 + 3 ... here()
    }
}


