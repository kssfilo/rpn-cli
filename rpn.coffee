math=require 'mathjs'

T=console.log
E=console.error

display=->
	@map (x)->
		if typeof x is 'string'
			return math.eval x
		else
			return x

rpn=(params,debugConsole=null)->
	step=0
	stack=[]
	stack.display=display

	while params.length>0
		p=params.shift()
		switch
			when typeof p is 'number'
				stack.push p.toString()

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
					when 'l' then ex="#{l} ^ #{r}"

				v=math.eval ex
				stack.push parseFloat v

			when p in ['n','i','s','a','l','c','f','u']
				if stack.length<1
					throw "'#{p}' needs 1 values"

				l=stack.pop()
				ex=''

				switch p
					when 'n' then ex="0-#{l}"
					when 'i' then ex="1/#{l}"
					when 's' then ex="sqrt(#{l})"
					when 'a' then ex="abs(#{l})"
					when 'l' then ex="log(#{l})"
					when 'c' then ex="ceil(#{l})"
					when 'f' then ex="floor(#{l})"
					when 'u' then ex="round(#{l})"

				v=math.eval ex
				stack.push parseFloat v

			when p in ['w']
				if stack.length<2
					throw "'#{p}' needs 2 values"
				switch p
					when 'w'
						r=stack.pop()
						l=stack.pop()
						stack.push r
						stack.push l

			when p in ['r']
				if stack.length<1
					throw "'#{p}' needs 1 values"
				switch p
					when 'r'
						r=stack.pop()
						stack.unshift r

			when p.match /^(-?[0-9.]+(e-?[0-9.]+)?|E)$/
				stack.push p

			else
				throw "'#{p}' unknown op"

		step++
		if debugConsole?
			debugConsole "step #{step}:[#{p}] #{stack.display().join ' '}"

	stack.display()

module.exports=rpn
