// AST node type
indirect enum Node {
    case number(Int)
    case addition(Node, Node)
    case subtractution(Node, Node)
    case multiplication(Node, Node)
    case division(Node, Node)
}

// Parser that parse from token sequence to AST.
final class Parser {
    private let tokenList: TokenList
    
    init(tokens: [Token]) {
        self.tokenList = TokenList(tokens: tokens)
    }

    func parse() -> Node {
        return expr()
    }

    // expr = mul ("+" mul | "-" mul)*
    private func expr() -> Node {
        var node = mul()
        
        while true {
            if consume("+") {
                node = .addition(node, mul())
            } else if consume("-") {
                node = .subtractution(node, mul())
            } else {
                return node
            }
        }
    }
    
    // mul = primary ("*" primary | "/" primary)*
    private func mul() -> Node {
        var node = primary()
        
        while true {
            if consume("*") {
                node = .multiplication(node, primary())
            } else if consume("/") {
                node = .division(node, primary())
            } else {
                return node
            }
        }
    }

    // primary = "(" expr ")" | num
    private func primary() -> Node {
        if consume("(") {
            let node = expr()
            guard consume(")") else {
                error("there is no assumed \")\"")
            }
            return node
        } else {
            guard let token = tokenList.next() else {
                error("there is no assumed integer")
            }
            
            if case .number(let value) = token.kind {
                tokenList.advanceCursol()
                return .number(value)
            } else {
                error("there is no assumed integer")
            }
        }
    }

    private func consume(_ op: String) -> Bool {
        guard let token = tokenList.next() else {
            return false
        }

        if op == token.kind.sign {
            tokenList.advanceCursol()
            return true
        } else {
            return false
        }
    }
}