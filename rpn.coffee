### jshint -W083 ###

math=require 'mathjs'

T=console.log
E=console.error

displayElement=(x)->
		if typeof x is 'string'
			return math.eval(x).toString()
		else
			return x.toString()

display=(stack)->stack.map displayElement

rpn=(formulaOrOptions)->
	formula=[]
	debugConsole=null
	precision=14

	switch
		when Array.isArray formulaOrOptions
			formula=formulaOrOptions
		when typeof(formulaOrOptions) is 'object' and Array.isArray(formulaOrOptions.formula)
			formula=formulaOrOptions.formula ? formula
			debugConsole=formulaOrOptions.debugConsole ? debugConsole
			precision=formulaOrOptions.precision ? precision
		else
			throw 'rpn:invalid formula'

	math.config
		number:'BigNumber'
		precision:precision

	step=0
	stack=[]
	registers={}
	applyAll=false

	while formula.length>0
		p=formula.shift()
		switch
			when typeof p is 'number'
				stack.push math.eval p

			when p in ['+','-','x','/','%','^','*','v']
				if stack.length<2
					throw "'#{p}' needs 2 values"

				r=stack.pop()

				f2=(p,l,r)->
					ex=''
					switch p
						when '+' then ex="#{l} + #{r}"
						when '-' then ex="#{l} - #{r}"
						when 'x','*' then ex="#{l} * #{r}"
						when '/' then ex="#{l} / #{r}"
						when '%' then ex="#{l} % #{r}"
						when '^' then ex="pow(#{l},#{r})"
						when 'v' then ex="nthRoot(#{l},#{r})"

					math.eval ex

				if applyAll
					stack=stack.map (l)->f2(p,l,r)
					applyAll=false
				else
					l=stack.pop()
					stack.push f2(p,l,r)

			when p in ['n','i','a','_','=','f','!','l','L','s','S','c','C','t','T']
				if stack.length<1
					throw "'#{p}' needs 1 values"

				f1=(p,l)->
					ex=''
					switch p
						when 'n' then ex="0-#{l}"
						when 'i' then ex="1/#{l}"
						when 'a' then ex="abs(#{l})"
						when 'l' then ex="log(#{l})"
						when 'L' then ex="exp(#{l})"
						when '_' then ex="floor(#{l})"
						when '=' then ex="round(#{l})"
						when 'f','!' then ex="factorial(#{l})"
						when 's' then ex="sin(#{l})"
						when 'c' then ex="cos(#{l})"
						when 't' then ex="tan(#{l})"
						when 'S' then ex="asin(#{l})"
						when 'C' then ex="acos(#{l})"
						when 'T' then ex="atan(#{l})"

					math.eval ex

				if applyAll
					stack=stack.map (l)->f1(p,l)
					applyAll=false
				else
					l=stack.pop()
					stack.push f1(p,l)

			when p in ['w']
				if stack.length<2
					throw "'#{p}' needs 2 values"
				switch p
					when 'w'
						r=stack.pop()
						l=stack.pop()
						stack.push r
						stack.push l

			when p in ['r','R','d','p','D','V']
				if stack.length<1
					throw "'#{p}' needs 1 values"
				switch p
					when 'r'
						r=stack.pop()
						stack.unshift r
					when 'R'
						r=stack.shift()
						stack.push r
					when 'd'
						r=stack.pop()
					when 'p'
						r=stack.pop()
						stack.push math.clone r
						stack.push r
					when 'D'
						stack=[]
					when 'V'
						stack=[stack.pop()]

			when p in ['P']
				stack.push 'PI'

			when p in ['F']
				applyAll=true

			when p in ['q','Q','y','Y']
				nElements=
					'q':1
					'Q':2
					'y':0
					'Y':1

				if stack.length<nElements[p]
					throw "'#{p}' needs #{nElements[p]} values"

				registerNumber='0'
				registerNumber=displayElement(stack.pop()) if p in ['q','Q']

				switch
					when p in ['Q','Y']
						registers[registerNumber]=stack.pop()
					when p in ['q','y']
						unless registers.hasOwnProperty registerNumber
							throw "Register #{registerNumber} is empty"
						stack.push math.clone registers[registerNumber]

			when p in ['N','M','m','A','X']
				if stack.length<1
					throw "'#{p}' needs 1 values"

				switch p
					when 'N'
						f=(i,x)->i.add 1
						i=math.eval 0
					when 'M'
						f=(i,x)->math.max i,x
						i=math.eval '-Infinity'
					when 'm'
						f=(i,x)->math.min i,x
						i=math.eval 'Infinity'
					when 'A'
						f=(i,x)->math.add i,x
						i=math.eval 0
					when 'X'
						f=(i,x)->math.multiply i,x
						i=math.eval 1

				stack.push stack.reduce(f,i)

			when p.match /^(-?[0-9.]+(e-?[0-9.]+)?)$/
				stack.push math.eval p

			else
				throw "'#{p}' unknown op"

		step++
		if debugConsole?
			debugText="step #{step}:[#{p}] #{display(stack).join ' '}#{if applyAll then '(F)' else ''}"
			if Object.keys(registers).length>0
				debugText+="\t:reg{#{("#{i}:#{displayElement v}" for i,v of registers).join ' '}}"
			debugConsole debugText

	display(stack)

module.exports=rpn
