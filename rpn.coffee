math=require 'mathjs'

T=console.log
E=console.error

display=->
	@map (x)->
		if typeof x is 'string'
			return math.eval(x).toString()
		else
			return x.toString()

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
	stack.display=display

	while formula.length>0
		p=formula.shift()
		switch
			when typeof p is 'number'
				stack.push math.eval p

			when p in ['+','-','x','/','%','^','*','v']
				if stack.length<2
					throw "'#{p}' needs 2 values"

				r=stack.pop()
				l=stack.pop()
				ex=''

				switch p
					when '+' then ex="#{l} + #{r}"
					when '-' then ex="#{l} - #{r}"
					when 'x','*' then ex="#{l} * #{r}"
					when '/' then ex="#{l} / #{r}"
					when '%' then ex="#{l} % #{r}"
					when '^' then ex="pow(#{l},#{r})"
					when 'v' then ex="nthRoot(#{l},#{r})"

				v=math.eval ex
				stack.push v

			when p in ['n','i','a','_','=','f','!','l','L','s','S','c','C','t','T']
				if stack.length<1
					throw "'#{p}' needs 1 values"

				l=stack.pop()
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

				v=math.eval ex
				stack.push v

			when p in ['w']
				if stack.length<2
					throw "'#{p}' needs 2 values"
				switch p
					when 'w'
						r=stack.pop()
						l=stack.pop()
						stack.push r
						stack.push l

			when p in ['r','R','d','p']
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
						stack.unshift math.clone r
						stack.unshift r

			when p in ['P']
				stack.push 'PI'

			when p.match /^(-?[0-9.]+(e-?[0-9.]+)?)$/
				stack.push math.eval p

			else
				throw "'#{p}' unknown op"

		step++
		if debugConsole?
			debugConsole "step #{step}:[#{p}] #{stack.display().join ' '}"

	stack.display()

module.exports=rpn
