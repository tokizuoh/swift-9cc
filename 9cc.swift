import Glibc

func error(_ message: String) {
    debugPrint(message)
    exit(1)
}

func convertOrder(opr: String, number: Int) -> String {
    if opr == "+" {
        return "  add rax, \(number)"
    } else if opr == "-" {
        return "  sub rax, \(number)"
    } else {
        fatalError()
    }
}

func main() {
    if (CommandLine.arguments.count != 1) {
        error("引数の個数が正しくありません")
    }

    print(".intel_syntax noprefix")
    print(".globl main")
    print("main:")

    var tmp = ""
    var opr = ""
    var isMoved = false

    let original = CommandLine.arguments[1]
    for c in original {
        let s: String = String(c)
        if Int(s) != nil {
            tmp += s
        }

        if s == "+" || s == "-" {
            if isMoved {
                if tmp.isEmpty {
                    error("予期しない文字列が含まれています: \(original)")
                }

                let order = convertOrder(opr: opr, number: Int(tmp)!)
                print(order)

                tmp = ""
                opr = s
            } else {
                if tmp.isEmpty {
                    error("予期しない文字列が含まれています: \(original)")
                } else {
                    print("  mov rax, \(Int(tmp)!)")
                    isMoved = true
                    tmp = ""
                    opr = s
                }
            }
        }
    }

    if !isMoved && !tmp.isEmpty {
        print("  mov rax, \(Int(tmp)!)")
        isMoved = false
        tmp = ""
    }

    if !opr.isEmpty && !tmp.isEmpty {
        let order = convertOrder(opr: opr, number: Int(tmp)!)
        print(order)
    }

    print("  ret")
}

main()
