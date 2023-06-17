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
            // Multi-letter punctuator -> Single-letter punctuator
            var isMatched = false
            for offset in [2, 1] {
                if let to = text.index(cursol, offsetBy: offset, limitedBy: text.endIndex) {
                    let op = text[cursol..<to]

                    let success = appendReservedTokenIfNeeded(op: op.description, numberString: &tmp)

                    if success {
                        cursol = to
                        isMatched = true
                    }
                }

                if isMatched {
                    break
                }
            }

            if isMatched {
                continue
            }

            // Single-number
            if let to = text.index(cursol, offsetBy: 1, limitedBy: text.endIndex) {
                let numberText = text[cursol..<to]
                if Int(String(numberText)) != nil {
                    tmp += String(numberText)
                    cursol = to
                    continue
                }
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

    private func appendReservedTokenIfNeeded(op: String, numberString: inout String) -> Bool {
        if let reserved = Token.TokenKind.Reserved(rawValue: op) {
            appendNumberTokenIfNeeded(numberString: &numberString)

            tokens.append(
                Token(
                    kind: Token.TokenKind.reserved(reserved),
                    position: 0
                )
            )

            return true
        }
        
        return false
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
