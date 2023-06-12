enum TokenKind {
    enum Reserved: String {
        case add = "+"
        case subtract = "-"
        case multiply = "*"
        case divide = "/"
        case leftParenthesis = "("
        case rightParenthesis = ")"
    }

    case reserved(Reserved)
    case number(Int)
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
                        kind: TokenKind.reserved(
                            TokenKind.Reserved(rawValue: String(t))!
                        ),
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

