import Foundation

func error(_ message: String) -> Never {
    print(message)
    exit(1)
}

func errorAt(_ message: String, inputText: String, offset: Int) -> Never {
    print(inputText)
    print(String(repeating: " ", count: offset), "^ ", message, separator: "")
    exit(1)
}
