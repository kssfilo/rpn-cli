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
	s=s.replace /([^e, ])-/g,'$1 - '
	s=s.replace /(-?[0-9.]+e?-?[0-9.]*)/g,' $1'
	s=s.replace /,/g,' '
	s.split(/ +/).filter (x)->x.length > 0
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
		version @PARTPIPE@VERSION@PARTPIPE@
		Copyright(c) 2017-@PARTPIPE@|date +%Y;@PARTPIPE@ @kssfilo(https://kanasys.com/gtech/)

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
			v:n-th root (element 1 root of element 2)
			2v:(combination) squrare root

			n:Negate last element
			i:Invert last element
			a:Absolute value (last element)
			l:Log e (last element)
			L:exponent of e (last element,reverse function of Log e)
			f:Factorial (last element,! is ok but need escape in bash)

			s:Sin (last element,ragian)
			c:Cos (last element,ragian)
			t:Tan (last element,radian)
			S:arcSin (last element,radian)
			C:arcCos (last element,radian)
			T:arcTan (last element,radian)
			P/180x:(combination) radian -> degree (last element)
			180/Px:(combination) degree -> radian (last element)

			_:floor last element
			=:round last element
			1+_:(combination) ceil last element

			w:sWap last 2 elements
			r:Rotate all elements(1 2 3 -> 3 1 2)
			R:Rotate all elements(1 2 3 -> 2 3 1)
			d:Drop last element
			D:Drop all elements
			V:Drop except last elements
			p:duP last element

			Y:move last element to 0th Register
			y:recall from 0th Register
			Q:move element 2 to <element 1>th Register
			q:recall from <element 1>th Register

			N:couNt all elements and push to stack
			M:find Max of all elements and push to stack
			m:find Min of all elements and push to stack
			A:sum of All elements and push to stack
			X:product of all elements and push to stack

			F:apply next operator to all elements(1,2,3,F,1,+ -> 2,3,4)

			NyAY/V:(combination) arithmetic mean(avarage)
			NyXYvV:(combination) geometric mean
			NyAY/F-F2^AY1-/2vV:(combination) standard deviation

		constants:
			P:Pi
			1L:(combination) base of natural logarithm(e)

		number:
			e:Exponent (5e3 -> 5000/5e-3 -> 0.005)
			-:negative(<any operator/number>- -> subtract,for example:1-1 -> 1 - 1 but 1 -1 -> 1 -1)

		example:
			#{appName} 1 2 +  #result:3
			#{appName} 1 2 1++ #result:4
			#{appName} 1,2,1++ #result:4
			
			#{appName} 1 2 1 + +|#{appName} -s 3 + #pipeline:same as #{appName} 1 2 1 + + 3 +
			#{appName} -s <<<'1 2 +' #dc style
			
			#{appName} 5e3 5 / #same as #{appName} 5000 5 /
			#{appName} 10 3 /=  #round:3.3333 -> 3

		"""
	else
		try
			T require('./rpn')({formula,debugConsole,precision}).join(' ')
		catch e
			E e
