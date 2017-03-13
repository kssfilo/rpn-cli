#!/usr/bin/env coffee

opt=require 'getopt'
command='normal'
debugConsole=null
readFromStdin=false
precision=14

T=console.log
E=console.error

process.argv.shift()
appName=require('path').basename process.argv.shift()

optSymbols='h?dsb'
regex=/^-[h\?dsb]+$/
formula=process.argv.filter (x)->!x.match regex
options=process.argv.filter (x)->x.match regex

opt.setopt optSymbols,options
opt.getopt (o,p)->
	switch o
		when 'h','?'
			command='usage'
		when 'd'
			debugConsole=console.error
		when 's'
			readFromStdin=true
		when 'b'
			precision=64

parse=(formula)->
	s=formula.join ' '
	s=s.replace /([^-0-9.e])/g,' $1'
	s=s.replace /([0-9.])-/g,'$1 - '
	s=s.replace /([^e ])-/g,'$1 -'
	s=s.replace /(-?[0-9.]+e?-?[0-9.]*)/g,' $1'
	s=s.replace /,/g,' '
	s.split(/ +/).filter (x)->x.length>0
formula=parse formula
debugConsole? "params:#{formula.join ' '}"

if readFromStdin
	input=require('fs').readFileSync('/dev/stdin', 'utf8')
	parsedInput=input.split(/[\s\n]+/).filter (x)->x.length>0
	parsedInput=parse parsedInput
	debugConsole? "stdin:#{parsedInput.join ' '}"
	formula=parsedInput.concat formula

debugConsole? "formula:#{formula.join ' '}"

if formula.length is 0 and !readFromStdin
	command='usage'

switch command
	when 'usage'
		console.log """
		#{appName} [-#{optSymbols}] <formula>

		options:
			-d:debug
			-s:mix stdin "<stdin formula> <command line formula>"
			-b:64 digits precition mode (default:14 digits)
			-h/-?:this help

		operators:
			+:add last two stack elements
			-:subtract element 1 from element 2
			x:multiply last two stack elements (* is ok but need escape in bash)
			/:divide element 2 by element 1
			%:element 2 mod element 1
			^:raise element 2 to the power of element 1

			n:Negate last element
			i:Invert last element
			s:Square root (last element)
			a:Absolute value (last element)
			L:Log e (last element)
			E:exponent of e (last element)
			F:Factorial (last element,! is ok but need escape in bash)

			f:Floor last element
			c:Ceil last element
			u:roUnd last element

			w:sWap last 2 elements
			r:Rotate all elements(1 2 3 -> 3 1 2)
			d:Drop last element
			p:duP last element

		number:
			e:Exponent (5e3 -> 5000/5e-3 -> 0.005)
			-:minus(<number>- -> subtract, example:1-1 -> 1 - 1 but 1 1--1+ -> 1 1 - -1 +)

		example:
			#{appName} 1 2 +
			#{appName} 1 2+
			#{appName} 1 2 1++
			#{appName} 1,2,1++
			#{appName} 1 2 1 + +|#{appName} -s 3 + #pipeline:same as #{appName} 1 2 1 + + 3 +
			#{appName} -s <<<'1 2 +' #dc style
			#{appName} 5e3 5 / #same as #{appName} 5000 5 /
			#{appName} 10 3 /u  #round:3.3333 -> 3
		"""
	else
		try
			T require('./rpn')({formula,debugConsole,precision}).join(' ')
		catch e
			E e
