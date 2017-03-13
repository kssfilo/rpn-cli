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

			when p in ['+','-','x','/','%','^','*']
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
					when '^' then ex="#{l} ^ #{r}"

				v=math.eval ex
				stack.push v

			when p in ['n','i','s','a','c','f','u','F','!','L','E']
				if stack.length<1
					throw "'#{p}' needs 1 values"

				l=stack.pop()
				ex=''

				switch p
					when 'n' then ex="0-#{l}"
					when 'i' then ex="1/#{l}"
					when 's' then ex="sqrt(#{l})"
					when 'a' then ex="abs(#{l})"
					when 'L' then ex="log(#{l})"
					when 'E' then ex="exp(#{l})"
					when 'c' then ex="ceil(#{l})"
					when 'f' then ex="floor(#{l})"
					when 'u' then ex="round(#{l})"
					when 'F','!' then ex="factorial(#{l})"

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

			when p in ['r','d','p']
				if stack.length<1
					throw "'#{p}' needs 1 values"
				switch p
					when 'r'
						r=stack.pop()
						stack.unshift r
					when 'd'
						r=stack.pop()
					when 'p'
						r=stack.pop()
						stack.unshift math.clone r
						stack.unshift r

			when p.match /^(-?[0-9.]+(e-?[0-9.]+)?)$/
				stack.push math.eval p

			else
				throw "'#{p}' unknown op"

		step++
		if debugConsole?
			debugConsole "step #{step}:[#{p}] #{stack.display().join ' '}"

	stack.display()

module.exports=rpn
