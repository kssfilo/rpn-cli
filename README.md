# rpn-cli - Command Line RPN Calculator 

RPN(Reverse Polish Notation) HP stype calculator for command line. using math.js engine.

Similar to unix dc command but you can write formula in command line parameters not only stdin like below.

```
>rpn 1 2 +
#result:3

>echo $(rpn 1 2 +)
#result:3
```
- [npmjs(document)](https://www.npmjs.com/package/rpn-cli)
- [GitHub(bug report)](https://github.com/kssfilo/rpn-cli)
- [Home Page](https://kanasys.com/gtech/650)

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
@PARTPIPE@|dist/cli.js -h

see https://www.npmjs.com/package/rpn-cli

@PARTPIPE@
```

## Change Log

- 2.1.0:upgrades internal mathjs engine to v6
- 2.0.0:breaking change:store(y/q)/recall(Y/Q) -> store(Y/Q)/recall(y/q)
- 1.1.0:added statistics operator:count(N)/sum(A)/product(X)/max(M)/min(m)
- 1.1.0:added register feature:store(y/q)/recall(Y/Q)
- 1.1.0:added various removing operator:except last element(V)/all(D)
- 0.3.x:added sin(s)/cos(c)/tan(t)/asin(S)/acos(C)/atan(T)/Pi(P)/v(n-th root)/R(reverse rotate)
- 0.3.x:s(square root) has been deprecated(use 2v)
- 0.3.x:c(ceil) has been deprecated(use 1+_)
- 0.2.x:added factorial(f)/drop(d)/dup(p)/log(l)/exponent(L)/-b option
- 0.2.x:constant E has been deprecated(use 1E)
- 0.1.x:added ceil(c)/floor(f)/round(r)
- 0.0.x:first release
