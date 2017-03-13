rpn-cli
==========

RPN(Reverse Polish Notation) calculator for command line.

Similar to unix dc command but you can write formula in command line parameters not only stdin like below.
```
>rpn 1 2 +
#result:3

>echo $(rpn 1 2 +)
#result:3
```

dc style is also suported(-s option). You can mix stdin formula and command line.

```
>rpn -s <<<'1 2 +'
#result:3

>echo '1 2'|rpn -s +
#same as rpn 1 2 +

>rpn '1 1 1 +'|rpn -s +
#pipeline,same as echo '1 2'|rpn -s +
```

Compare to ruby rcalc, rpn-cli is simple but is designed for easy and short to type formula. For example, "(sin(1/3) - cos(1/3))^2" is "3 inv dup sin swap cos - sqr p" in rcalc, "3ipswc-2^" in rpn-cli.

All operators are single charactor and not necessary to be escaped in bash shell.

Multiply can be "x" (to avoid bash * wildcard) 

```
>rpn 2 2 x
#result:4
```

Seperator(white space) can be comma(,) or omit it

```
>rpn 2,2x
#result:4

>rpn 1,1,1,1++++
#result:4
```

You can use rpn-cli as module.

```
rpn=require("rpn-cli");
try{
	rs=rpn([1,2,'+']);
	console.log(rs[0]); //'3'
}catch(e){
	console.error(e);
}
```

## Install

```
sudo npm install -g rpn-cli
```

## Usage

```
@SEE_NPM_README@
```

## Change Log

- 0.3.x:added sin(s)/cos(c)/tan(t)/asin(S)/acos(C)/atan(T)/Pi(P)/v(n-th root)/R(reverse rotate)
- 0.3.x:s(square root) has been deprecated(use 2v)
- 0.3.x:c(ceil) has been deprecated(use 1+_)
- 0.2.x:added factorial(F)/drop(d)/dup(p)/log(L)/exponent(E)/-b option
- 0.2.x:constant E has been deprecated(use 1E)
- 0.1.x:added ceil(c)/floor(f)/round(r)
- 0.0.x:first release
