func main() {
    guard CommandLine.arguments.count == 2 else {
        error("引数の個数が正しくありません")
    }

    let inputText = CommandLine.arguments[1]

    let tokens = Tokenizer.tokenize(text: inputText)

    print(".intel_syntax noprefix")
    print(".globl main")
    print("main:")

    var isFirst = true
    var tmpOperator: TokenKind.Operator? = nil
    for token in tokens {
        if isFirst {
            guard case .number(let value) = token.kind else {
                errorAt(
                    "数ではありません",
                    inputText: inputText,
                    offset: token.position
                )
            }

            print("  mov rax, \(value)")

            isFirst = false
        } else {
            if let _tmpOperator = tmpOperator {
                guard case .number(let value) = token.kind else {
                    errorAt(
                        "数ではありません",
                        inputText: inputText,
                        offset: token.position
                    )
                }

                switch _tmpOperator {
                    case .plus:
                        print("  add rax, \(value)")
                    case .minus:
                        print("  sub rax, \(value)")
                }
                tmpOperator = nil
            } else {
                guard case .reserved(let ope) = token.kind else {
                    error("+か-の符号ではありません")
                }

                tmpOperator = ope
            }
        }

    }

    print("  ret")
    return
}

main()
