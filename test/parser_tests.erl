-module(parser_tests).

-include_lib("eunit/include/eunit.hrl").

terminals_parser_test() ->
    ?assertEqual({number, 1}, parse("1")),
    ?assertEqual({var, a2}, parse("a2")).

simple_expression_test() ->
    ?assertEqual({add, {number, 1}, {number, 2}}, parse("1 + 2")),
    ?assertEqual({subtr, {number, 1}, {number, 2}}, parse("1 - 2")),
    ?assertEqual({mult, {number, 1}, {number, 2}}, parse("1 * 2")),
    ?assertEqual({divd, {number, 1}, {number, 2}}, parse("1 / 2")).

operator_precedence_test() ->
    ?assertEqual({add, 
        {number, 1},
        {mult, {number, 2}, {number, 3}}},
        parse("1 + 2 * 3")),
    ?assertEqual({divd,
        {mult, {number, 1}, {number, 2}},
        {number, 3}},
        parse("1 * 2 / 3")).

parentheses_test() ->
    ?assertEqual({mult, 
        {number, 1},
        {add, {number, 2}, {number, 3}}},
        parse("1 * (2 + 3)")).

parse(Str) ->
    Tokens = tokens(Str),
    unwrap(calculator_parser:parse(Tokens)).

unwrap({ok, V}) ->
    V.

tokens(Str) ->
    {ok, Tokens, _} = calculator_lexer:string(Str),
    Tokens.