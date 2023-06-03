enum TokenKind {
    enum Operator {
        case plus
        case minus
    }

    case reserved(Operator)
    case number(Int)
}

struct Token {
    let kind: TokenKind
    let position: Int
}

func tokenize(text: String) -> [Token] {
    var tokens: [Token] = []

    var tmp = ""
    var tmpOffset = -1
    for (offset, t) in text.enumerated() {
        if t.isWhitespace {
            continue
        }

        if t == "+" || t == "-" {
            if !tmp.isEmpty, tmpOffset != -1 {
                tokens.append(
                    Token(
                        kind: .number(Int(tmp)!),
                        position: tmpOffset
                    )
                )
                tmp = ""
                tmpOffset = -1
            }

            tokens.append(
                Token(
                    kind: .reserved(t == "+" ? .plus : .minus),
                    position: offset
                )
            )
            continue
        }

        if Int(String(t)) != nil {
            if tmp.isEmpty {
                tmpOffset = offset
            }
            tmp += String(t)
            continue
        }

        errorAt(
            "トークナイズできません",
            inputText: text,
            offset: offset
        )
    }

    // TODO: 共通化
    if !tmp.isEmpty, tmpOffset != -1 {
        tokens.append(
            Token(
                kind: .number(Int(tmp)!),
                position: tmpOffset
            )
        )
        tmp = ""
        tmpOffset = -1
    }

    return tokens
}

func main() {
    guard CommandLine.arguments.count == 2 else {
        error("引数の個数が正しくありません")
    }

    let inputText = CommandLine.arguments[1]

    let tokens = tokenize(text: inputText)

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
