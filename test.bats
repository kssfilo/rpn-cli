#!/usr/bin/env bats

@test "+" {
	[ "$(dist/cli.js 1 1 +)" = "2" ]
}

@test "-" {
	[ "$(dist/cli.js 2 1 -)" = "1" ]
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

@test "E/l" {
	[ "$(dist/cli.js E l)" = "1" ]
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


@test "pipe" {
	[ "$(dist/cli.js 5 2 +|dist/cli.js -s 3 +)" = "10" ]
}

@test "parser" {
	[ "$(dist/cli.js 1 1 -1,1,-1++++)" = "1" ]
}
