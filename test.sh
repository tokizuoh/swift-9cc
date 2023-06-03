#!/bin/bash

assert() {
  expected="$1"
  input="$2"

  cat *.swift > main.swift
  swift main.swift "$input" > tmp.s
  rm main.swift
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

# ステップ1: 整数1個をコンパイルする言語の作成
assert 0 0
assert 42 42

# ステップ2: 加減算のできるコンパイラの作成
assert 21 "5+20-4"
assert 6 "7-1"

# ステップ3：トークナイザを導入
assert 41 " 12 + 34 - 5 "

echo OK
