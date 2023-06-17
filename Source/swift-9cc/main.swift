#if os(Linux)
import Glibc
#else
import Darwin
#endif

func error(_ message: String) -> Never {
    print(message)
    exit(1)
}

func errorAt(_ message: String, inputText: String, offset: Int) -> Never {
    print(inputText)
    print(String(repeating: " ", count: offset), "^ ", message, separator: "")
    exit(1)
}

func main() {
    guard CommandLine.arguments.count == 2 else {
        error("invalid number of arguments \(CommandLine.arguments)")
    }

    // Tokenize and parse.
    let tokens = Tokenizer(text: CommandLine.arguments[1]).tokenize()
    let node = Parser(tokens: tokens).parse()
    
    // Generate assembly.
    let columns = Generator.generate(from: node)
    
    // Print out assembly.
    columns.forEach { column in
        print(column)
    }
}

main()
