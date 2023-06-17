enum TokenKind {
    enum Reserved: String {
        case add = "+"
        case subtract = "-"
        case multiply = "*"
        case divide = "/"
        case leftParenthesis = "("
        case rightParenthesis = ")"
        case equal = "=="
        case notEqual = "!="
        case lessThan = "<"
        case lessThanOrEqual = "<="
        case moreThan = ">"
        case moreThanOrEqual = ">="
    }

    case reserved(Reserved)
    case number(Int)
}

struct Token {
    let kind: TokenKind
    let position: Int
}

final class Tokenizer {
    private var tokens: [Token] = []
    private lazy var cursol = text.startIndex
    
    private let text: String
    
    init(text: String) {
        self.text = text.filter { !$0.isWhitespace }
    }
    
    func tokenize() -> [Token] {
        var tmp = ""
        while cursol != text.endIndex {
            if let to = text.index(cursol, offsetBy: 2, limitedBy: text.endIndex) {
                let token: Token? = {
                    let op = String(text[cursol..<to])
                    switch op {
                    case "==", "!=", "<=", ">=":
                        return Token(
                            kind: .reserved(TokenKind.Reserved(rawValue: op)!),
                            position: 0
                        )
                    default:
                        return nil
                    }
                }()
                
                if let token {
                    appendNumberTokenIfNeeded(numberString: &tmp)
                    
                    tokens.append(token)
                    cursol = to
                    continue
                }
            }

            guard let to = text.index(cursol, offsetBy: 1, limitedBy: text.endIndex) else {
                break
            }
            var isMatched = false
            "+-*/()<>".forEach { c in
                let op = String(c)
                if text[cursol..<to] == op {
                    appendNumberTokenIfNeeded(numberString: &tmp)
                    
                    tokens.append(
                        Token(
                            kind: TokenKind.reserved(
                                TokenKind.Reserved(rawValue: op)!
                            ),
                            position: 0 // TODO
                        )
                    )
                    cursol = text.index(after: cursol)
                    isMatched = true
                }
            }

            let now = text[cursol..<to]
            if Int(String(now)) != nil {
                tmp += String(now)
                cursol = text.index(after: cursol)
                continue
            }
            
            if isMatched {
                continue
            }
            
            errorAt(
                "invalid token",
//                "invalid token \(text[cursol])",
                inputText: text,
                offset: 0  // TODO
            )
        }

        appendNumberTokenIfNeeded(numberString: &tmp)
        
        return tokens
    }

    private func appendNumberTokenIfNeeded(numberString: inout String) {
        if !numberString.isEmpty {
            tokens.append(
                Token(
                    kind: .number(Int(numberString)!),
                    position: 0  // TODO
                )
            )
            numberString = ""
        }
    }
}
