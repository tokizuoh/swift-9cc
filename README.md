# swift-9cc
C compiler written in Swift with reference to https://www.sigbus.info/compilerbook.

- Step1: [33ec617](https://github.com/tokizuoh/swift-9cc/commit/33ec61766d5f98e4c7fd19a3e75204802be220a7)
- Step2: [fba7a80](https://github.com/tokizuoh/swift-9cc/commit/fba7a80632faf94c0997b88ec3f5e54f5fa4231d)
- Step3: [58e4ce9](https://github.com/tokizuoh/swift-9cc/commit/58e4ce9b607cac7d50b3ab727acda5bdd59a5483)
- Step4: [65ab533](https://github.com/tokizuoh/swift-9cc/commit/65ab533929874bc4169f9299ff15c76aa84eb712)
- Step5: [d4e96c8](https://github.com/tokizuoh/swift-9cc/commit/d4e96c8bb8cbfb6354f696b22b38ac04b8cb58c7)  
  
## Usage

```sh
$ swift run swift-9cc "(5*(7-1)+3)"
Building for debugging...
Build complete! (0.10s)

.intel_syntax noprefix
.globl main
main:
  push 5
  push 7
  push 1
  pop rdi
  pop rax
  sub rax, rdi
  push rax
  pop rdi
  pop rax
  imul rax, rdi
  push rax
  push 3
  pop rdi
  pop rax
  add rax, rdi
  push rax
  pop rax
  ret
```
