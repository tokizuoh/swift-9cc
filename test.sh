#!/bin/bash

binpath=""

assert() {
  expected="$1"
  input="$2"

  "$binpath/swift-9cc" "$input" > tmp.s
  cc -o tmp tmp.s
  ./tmp
  actual="$?"

  if [ "$actual" = "$expected" ]; then
    echo "$input => $actual"
  else
    echo "$input => $expected expected, but got $actual"
    exit 1
  fi
}

swift build
binpath=`swift build --show-bin-path`

# ステップ1: 整数1個をコンパイルする言語の作成
assert 0 0
assert 42 42

# ステップ2: 加減算のできるコンパイラの作成
assert 21 "5+20-4"
assert 6 "7-1"

# ステップ3：トークナイザを導入
assert 41 " 12 + 34 - 5 "

# ステップ5: 四則演算のできる言語の作成
assert 47 '5+6*7'
assert 15 '5*(9-6)'
assert 4 '(3+5)/2'

# ステップ6: 単項プラスと単項マイナス
assert 10 '-10+20'
assert 10 '- -10'
assert 10 '- - +10'
assert 17 '-(-10)+7'

# ステップ7: 比較演算子
assert 0 '0==1'
assert 1 '42==42'
assert 1 '0!=1'
assert 0 '42!=42'

assert 1 '0<1'
assert 0 '1<1'
assert 0 '2<1'
assert 1 '0<=1'
assert 1 '1<=1'
assert 0 '2<=1'

assert 1 '1>0'
assert 0 '1>1'
assert 0 '1>2'
assert 1 '1>=0'
assert 1 '1>=1'
assert 0 '1>=2'

assert 1 '(6+2)==8'
assert 1 '(6-2)==4'
assert 1 '(6*2)==12'
assert 1 '(6/2)==3'

assert 1 '2*4==8'
assert 0 '2*(4==8)'

echo OK
