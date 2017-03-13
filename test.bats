#!/usr/bin/env bats

@test "+" {
	[ "$(dist/cli.js 1 1 +)" = "2" ]
}

@test "-" {
	[ "$(./cli.coffee -2,-2-2- -2,2x-2-)" = "0" ]
}

@test "x" {
	[ "$(dist/cli.js 1 2 x)" = "2" ]
}

@test "/" {
	[ "$(dist/cli.js 4 2 /)" = "2" ]
}

@test "^" {
	[ "$(dist/cli.js -4 2 ^)" = "16" ]
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

@test "v" {
	[ "$(dist/cli.js 4 2v)" = "2" ]
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

@test "r/R" {
	[ "$(dist/cli.js 2,3,5r+R/)" = "1" ]
}

@test "s/c/t/S/C/T/P" {
	[ "$(dist/cli.js -b P8/cP8/t*P8/s/,1T2x.5C.5S++P/-)" = "0" ]
}


@test "e" {
	[ "$(dist/cli.js 1e10 1e-10 x)" = "1" ]
}

@test "_" {
	[ "$(dist/cli.js 1.5_)" = "1" ]
}

@test "=" {
	[ "$(dist/cli.js 1.5=)" = "2" ]
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
