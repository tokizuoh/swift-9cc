func error(_ message: String) {
    fatalError(message)
}

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
}

func tokenize(text: String) -> [Token] {
    var tokens: [Token] = []

    var tmp = ""
    for t in text {
        if t.isWhitespace {
            continue
        }

        if t == "+" || t == "-" {
            if !tmp.isEmpty {
                tokens.append(Token(kind: .number(Int(tmp)!)))
                tmp = ""
            }

            tokens.append(Token(kind: .reserved(t == "+" ? .plus : .minus)))
            continue
        }

        if Int(String(t)) != nil {
            tmp += String(t)
            continue
        }

        error("トークナイズできません")
    }

    // TODO: 共通化
    if !tmp.isEmpty {
        tokens.append(Token(kind: .number(Int(tmp)!)))
        tmp = ""
    }

    return tokens
}

func main() {
    if (CommandLine.arguments.count != 2) {
        error("引数の個数が正しくありません")
    }

    let tokens = tokenize(text: CommandLine.arguments[1])

    print(".intel_syntax noprefix")
    print(".globl main")
    print("main:")

    var isFirst = true
    var tmpOperator: TokenKind.Operator? = nil
    for token in tokens {
        if isFirst {
            guard case .number(let value) = token.kind else {
                error("数ではありません")
                return
            }

            print("  mov rax, \(value)")

            isFirst = false
        } else {
            if let _tmpOperator = tmpOperator {
                guard case .number(let value) = token.kind else {
                    error("数ではありません")
                    return
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
                    return
                }

                tmpOperator = ope
            }
        }

    }

    print("  ret")
    return
}

main()
