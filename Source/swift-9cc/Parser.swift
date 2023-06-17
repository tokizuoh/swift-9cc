// List of Token that can be read ahead element.
private final class TokenList {
    private let tokens: [Token]
    private var cursol = 0

    init(tokens: [Token]) {
        self.tokens = tokens
    }

    func next() -> Token? {
        guard tokens.indices.contains(cursol) else {
            return nil
        }

        let token = tokens[cursol]
        return token
    }

    func advanceCursol() {
        cursol += 1
    }
}

// AST node type
indirect enum Node {
    case number(Int)
    case addition(Node, Node)
    case subtractution(Node, Node)
    case multiplication(Node, Node)
    case division(Node, Node)
    case equal(Node, Node)
    case notEqual(Node, Node)
    case lessThan(Node, Node)
    case lessThanOrEqual(Node, Node)
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

    // expr = equality
    private func expr() -> Node {
        return equality()
    }

    // equality = relational | ("==" relational | "!=" relational)*
    private func equality() -> Node {
        var node = relational()
        
        while true {
            if consume("==") {
                node = .equal(node, relational())
            } else if consume("!=") {
                node = .notEqual(node, relational())
            } else {
                return node
            }
        }
    }

    // relational = add ("<" add | "<=" add | ">" add | ">=" add)*
    private func relational() -> Node {
        var node = add()

        while true {
            if consume("<") {
                node = .lessThan(node, add())
            } else if consume("<=") {
                node = .lessThanOrEqual(node, add())
            } else if consume(">") {
                node = .lessThan(add(), node)
            } else if consume(">=") {
                node = .lessThanOrEqual(add(), node)
            } else {
                return node
            }
        }
    }

    // add = mul ("+" mul | "-" mul)*
    private func add() -> Node {
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
    
    // mul = unary ("*" unary | "/" unary)*
    private func mul() -> Node {
        var node = unary()
        
        while true {
            if consume("*") {
                node = .multiplication(node, unary())
            } else if consume("/") {
                node = .division(node, unary())
            } else {
                return node
            }
        }
    }

    // unary = ("+" | "-")? primary
    private func unary() -> Node {
        if consume("+") {
            return unary()
        } else if consume("-") {
            return .subtractution(.number(0), unary())
        } else {
            return primary()
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

        switch token.kind {
        case .number(_):
            return false
        case .reserved(let reserved):
            if op == reserved.rawValue {
                tokenList.advanceCursol()
                return true
            } else {
                return false
            }
        }
    }
}
