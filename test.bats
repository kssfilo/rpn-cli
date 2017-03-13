#!/usr/bin/env bats

@test "+" {
	[ "$(dist/cli.js 1 1 +)" = "2" ]
}

@test "-" {
	[ "$(dist/cli.js 40 10-10-20--20-20-)" = "0" ]
}

@test "x" {
	[ "$(dist/cli.js 1 2 x)" = "2" ]
}

@test "/" {
	[ "$(dist/cli.js 4 2 /)" = "2" ]
}

@test "^" {
	[ "$(dist/cli.js 4 2 ^)" = "16" ]
}

@test "%" {
	[ "$(dist/cli.js 5 2 %)" = "1" ]
}

@test "n" {
	[ "$(dist/cli.js 2 n)" = "-2" ]
}

@test "i" {
	[ "$(dist/cli.js 0.5 i)" = "2" ]
}

@test "s" {
	[ "$(dist/cli.js 4 s)" = "2" ]
}

@test "a" {
	[ "$(dist/cli.js -4 a)" = "4" ]
}

@test "E/L" {
	[ "$(dist/cli.js 100 L E)" = "100" ]
}

@test "w" {
	[ "$(dist/cli.js 2,4w/)" = "2" ]
}

@test "r" {
	[ "$(dist/cli.js 2,1,4rx-)" = "2" ]
}

@test "e" {
	[ "$(dist/cli.js 1e10 1e-10 x)" = "1" ]
}

@test "f" {
	[ "$(dist/cli.js 1.5f)" = "1" ]
}

@test "c" {
	[ "$(dist/cli.js 1.5c)" = "2" ]
}

@test "u" {
	[ "$(dist/cli.js 1.5u)" = "2" ]
}

@test "F" {
	[ "$(dist/cli.js 5F 5\! +)" = "240" ]
}

@test "d/p" {
	[ "$(dist/cli.js 1 2 3 d p + +)" = "5" ]
}

@test "pipe" {
	[ "$(dist/cli.js 5 2 +|dist/cli.js -s 3 +)" = "10" ]
}

@test "parser" {
	[ "$(dist/cli.js 1 1 -1,1,-1++++10e-2+0.01e1-)" = "1" ]
}

@test "big preciiton" {
	[ "$(dist/cli.js -b 100 L)" = "4.605170185988091368035982909368728415202202977257545952066655802" ]
}
