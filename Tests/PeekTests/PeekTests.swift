import XCTest
@testable import Peek

class PeekTests: XCTestCase {
    
    func test_peek() {
        peek()
        5.peek("✅")
        peek(\.className)
        peek("✅", \.className){ print("❗️log", $0.log()) }
        5 >> "✅"
        5 >> "✅".here()
        print( "⚠️".error() )
        5 >> here()
    }
}


