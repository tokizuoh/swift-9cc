enum TokenKind {
    case add
    case subtract
    case multiply
    case divide
    case leftParenthesis
    case rightParenthesis
    case number(Int)

    var sign: String? {
        switch self {
        case .add:
            return "+"
        case .subtract:
            return "-"
        case .multiply:
            return "*"
        case .divide:
            return "/"
        case .leftParenthesis:
            return "("
        case .rightParenthesis:
            return ")"
        case .number(_):
            return nil
        }
    }
    
    // TODO: Initializing from a Raw Value を使いたい
    // https://docs.swift.org/swift-book/documentation/the-swift-programming-language/enumerations/#Initializing-from-a-Raw-Value
    static func get(from value: String) -> Self? {
        switch value {
        case "+":
            return .add
        case "-":
            return .subtract
        case "*":
            return .multiply
        case "/":
            return .divide
        case "(":
            return .leftParenthesis
        case ")":
            return .rightParenthesis
        default:
            return nil
        }
    }
}

struct Token {
    let kind: TokenKind
    let position: Int
}

enum Tokenizer {
    private static let punctuator = "+-*/()"
    
    static func tokenize(text: String) -> [Token] {
        var tokens: [Token] = []

        var tmp = ""
        var tmpOffset = -1
        for (offset, t) in text.enumerated() {
            if t.isWhitespace {
                continue
            }

            if Self.punctuator.contains(t) {
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
                        kind: TokenKind.get(from: String(t))!,
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
                "invalid token",
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
}

