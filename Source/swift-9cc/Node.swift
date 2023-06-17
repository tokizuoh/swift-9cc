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
