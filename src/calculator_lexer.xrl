Definitions.

D = [0-9]
WS = [\s\t]
LB = \n|\r\n|\r
L = [A-Za-z]
C = [A-Za-z0-9]

Rules.
{L}{C}* : {token, {var, TokenLine, list_to_atom(TokenChars)}}.
{D}+    : {token, {number, TokenLine, list_to_integer(TokenChars)}}.
[\+]    : {token, {plus, TokenLine}}.
[\-]    : {token, {minus, TokenLine}}.
[\*]    : {token, {mult, TokenLine}}.
[\/]    : {token, {divd, TokenLine}}.
[\(]    : {token, {lparen, TokenLine}}.
[\)]    : {token, {rparen, TokenLine}}.
{WS}    : skip_token.
{LB}    : skip_token.

Erlang code.
