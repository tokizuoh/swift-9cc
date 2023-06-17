struct Token {
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

    
    let kind: TokenKind
    let position: Int
}
