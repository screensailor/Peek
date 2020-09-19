extension String {

    @inlinable public func here(_ function: String = #function, _ file: String = #file, _ line: Int = #line) -> String {
        "\(self) ← \(CodeLocation(function, file, line))"
    }
    
    @inlinable public func error(_ function: String = #function, _ file: String = #file, _ line: Int = #line) -> CodeLocation.Error {
        CodeLocation.Error(self, function, file, line)
    }
}
