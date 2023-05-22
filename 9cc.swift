import Glibc

func main() {
    if (CommandLine.arguments.count != 2) {
        debugPrint("引数の個数が正しくありません")
        exit(1)
    }

    print(".intel_syntax noprefix")
    print(".globl main")
    print("main:")
    print("  mov rax, \(Int(CommandLine.arguments[1])!)")
    print("  ret")
}

main()
