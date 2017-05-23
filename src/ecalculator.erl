-module(ecalculator).

%% API exports
-export([calculate/2]).

-ifdef (TEST).
-compile(export_all).
-endif.

-type expr() :: { number, integer() }
              | { add, expr(), expr() }
              | { subtr, expr(), expr() }
              | { mult, expr(), expr() }
              | { divd, expr(), expr() }
              | { var, atom() }.

-type env() :: [{ atom(), integer() }].

-type instr() :: { push, integer() }
              |  { fetch, atom() }
              |  { add }
              |  { subtr }
              |  { mult }
              |  { divd }.

-type program() :: [instr()].

-type stack() :: [integer()].

-spec parse(string()) -> expr().

-spec eval(env(), expr()) -> integer().

-spec lookup(atom(), env()) -> integer().

-spec compile(expr()) -> program().

-spec run(env(), program()) -> integer().

-spec run(env(), program(), stack()) -> integer().

%%====================================================================
%% API functions
%%====================================================================

calculate(Env, Expression) ->
    eval(Env, parse(Expression)).

calculate_compiled(Env, Expression) ->
    Compiled = compile(parse(Expression)),
    run(Env, Compiled).

%%====================================================================
%% Internal functions
%%====================================================================
parse(Str) ->
    {ok, Tokens, _} = calculator_lexer:string(Str),
    {ok, Expr} = calculator_parser:parse(Tokens),
    Expr.

eval(_Env, {number, N}) -> N;

eval(Env, {add, L, R}) ->
    eval(Env, L) + eval(Env, R);

eval(Env, {subtr, L, R}) ->
    eval(Env, L) - eval(Env, R);

eval(Env, {mult, L, R}) ->
    eval(Env, L) * eval(Env, R);

eval(Env, {divd, L, R}) ->
    eval(Env, L) / eval(Env, R);

eval(Env, {var, Name}) ->
    lookup(Name, Env).

compile({number, N}) ->
    [{push, N}];

compile({var, A}) ->
    [{fetch, A}];

compile({Operation, L, R}) ->
    compile(L) ++ compile(R) ++ [{Operation}].

run(Env, Program) ->
    run(Env, Program, []).

run(_Env, [], [Result]) ->
    Result;

run(Env, [{push, N}|Cont], Stack) ->
    run(Env, Cont, [N|Stack]);

run(Env, [{fetch, A}|Cont], Stack) ->
    run(Env, Cont, [lookup(A, Env)|Stack]);

run(Env, [{add}|Cont], [A1, A2|Rest]) ->
    run(Env, Cont, [(A1 + A2)|Rest]);

run(Env, [{subtr}|Cont], [A1, A2|Rest]) ->
    run(Env, Cont, [(A1 - A2)|Rest]);

run(Env, [{mult}|Cont], [A1, A2|Rest]) ->
    run(Env, Cont, [(A1 * A2)|Rest]);

run(Env, [{divd}|Cont], [A1, A2|Rest]) ->
    run(Env, Cont, [(A1 / A2)|Rest]).

lookup(A, [{A, V}|_]) ->
    V;

lookup(A, [_|Rest]) ->
    lookup(A, Rest).

