// List of Token that can be read ahead element.
final class TokenList {
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
