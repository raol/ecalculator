Nonterminals
expression term factor.

Terminals
number plus minus mult divd lparen rparen var.

Rootsymbol expression.

expression -> term: '$1'.
expression -> expression plus term: { add, '$1', '$3' }.
expression -> expression minus term: { subtr, '$1', '$3' }.

term -> term mult factor: { mult, '$1', '$3' }.
term -> term divd factor: { divd, '$1', '$3' }.
term -> factor: '$1'.

factor -> number: { number, unwrap('$1') }.
factor -> var: { var, unwrap('$1') }.
factor -> lparen expression rparen: '$2'.

Erlang code.

unwrap({_,_,V}) -> V.