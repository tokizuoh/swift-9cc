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

enum Tokenizer {
    static func tokenize(text: String) -> [Token] {
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
}

