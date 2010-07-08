-module(beam_callee).
-on_load(on_load/0).
-export([f/0]).

on_load() ->
    ok.

f() ->
    false = code:is_module_native(?MODULE),
    ok.
