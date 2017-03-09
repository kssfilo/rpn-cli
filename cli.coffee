#!/usr/bin/env coffee

opt=require 'getopt'
command='normal'
debugConsole=null
readFromStdin=false

T=console.log
E=console.error

process.argv.shift()
appName=require('path').basename process.argv.shift()

optSymbols='h?ds'
regex=/^-[h\?ds]+$/
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

parse=(formula)->
	s=formula.join ' '
	s=s.replace /([^-0-9.e])/g,' $1'
	s=s.replace /([^e])-/g,'$1 -'
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
			-h/-?:this help

		operators:
			+:add last two stack elements
			-:subtract element 1 from element 2
			x:multiply last two stack elements (not *:)
			/:divide element 2 by element 1
			%:element 2 mod element 1
			^:raise element 2 to the power of element 1
			n:Negatelast element
			i:Invert last element
			s:Square root function
			a:Absolute value function
			f:Floor last element
			c:Ceil last element
			u:roUnd last element
			l:natural Logarithm function
			w:sWap last 2 elements
			r:Rotate all elements(1 2 3 -> 3 1 2)
			E:base of natural logarithm
			e:Exponential function(5e3 -> 5000/5e-3 -> 0.005)

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
			T require('./rpn')(formula,debugConsole).join(' ')
		catch e
			E e
