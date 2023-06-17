// Generator that generate assembly from AST.
enum Generator {
    private static var columns: [String] = []
    
    static func generate(from node: Node) -> [String] {
        // Print out the first half of assembly.
        columns.append(".intel_syntax noprefix")
        columns.append(".globl main")
        columns.append("main:")

        // Traverse the AST to emit assembly.
        walk(from: node)
        
        // A result must be at the top of the stack, so pop it
        // to RAX to make it a program exit code.
        columns.append("  pop rax")
        columns.append("  ret")
        
        return columns
    }
    
    private static func walk(from node: Node) {
        switch node {
        case .addition(let lhs, let rhs),
                .subtractution(let lhs, let rhs),
                .multiplication(let lhs, let rhs),
                .division(let lhs, let rhs),
                .equal(let lhs, let rhs),
                .notEqual(let lhs, let rhs),
                .lessThan(let lhs, let rhs),
                .lessThanOrEqual(let lhs, let rhs):
            walk(from: lhs)
            walk(from: rhs)
        case .number(let value):
            columns.append("  push \(value)")
            return
        }
        
        columns.append("  pop rdi");
        columns.append("  pop rax");
        
        switch node {
        case .addition(_, _):
            columns.append("  add rax, rdi")
        case .subtractution(_, _):
            columns.append("  sub rax, rdi")
        case .multiplication(_, _):
            columns.append("  imul rax, rdi")
        case .division(_, _):
            columns.append("  cqo")
            columns.append("  idiv rdi")
        case .number(_):
            error("unexpected error: will not reach here")
        case .equal(_, _):
            columns.append("  cmp rax, rdi")
            columns.append("  sete al")
            columns.append("  movzb rax, al")
        case .notEqual(_, _):
            columns.append("  cmp rax, rdi")
            columns.append("  setne al")
            columns.append("  movzb rax, al")
        case .lessThan(_, _):
            columns.append("  cmp rax, rdi")
            columns.append("  setl al")
            columns.append("  movzb rax, al")
        case .lessThanOrEqual(_, _):
            columns.append("  cmp rax, rdi")
            columns.append("  setle al")
            columns.append("  movzb rax, al")
        }
        
        columns.append("  push rax")
    }
}
