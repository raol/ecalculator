-module(lexer_tests).

-include_lib("eunit/include/eunit.hrl").

-define(VTOKEN, fun(Type, Value) -> {Type, 1, Value} end).
-define (STOKEN, fun(Type) -> {Type, 1} end).

lexer_single_token_test() ->
    ?assertEqual({ok, [?VTOKEN(number, 123)], 1}, calculator_lexer:string("123")),
    ?assertEqual({ok, [?VTOKEN(var, a12)], 1}, calculator_lexer:string("a12")),
    ?assertEqual({ok, [?STOKEN(plus)], 1}, calculator_lexer:string("+")),
    ?assertEqual({ok, [?STOKEN(minus)], 1}, calculator_lexer:string("-")),
    ?assertEqual({ok, [?STOKEN(mult)], 1}, calculator_lexer:string("*")),
    ?assertEqual({ok, [?STOKEN(divd)], 1}, calculator_lexer:string("/")),
    ?assertEqual({ok, [?STOKEN(lparen)], 1}, calculator_lexer:string("(")),
    ?assertEqual({ok, [?STOKEN(rparen)], 1}, calculator_lexer:string(")")).

lexer_ignores_whitespaces_test() ->
    ?assertEqual({ok, [?VTOKEN(number, 123)], 1}, calculator_lexer:string("   123")),
    ?assertEqual(
        {ok, [?VTOKEN(number, 1), ?STOKEN(plus), ?VTOKEN(number, 2)], 1}, 
        calculator_lexer:string("1 + 2")).