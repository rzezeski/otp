-module(native_caller).
-compile([native]).
-export([call/1]).

call(CalleeModuleName) ->
    true = code:is_module_native(?MODULE),
    ok = CalleeModuleName:f(),
    ok = CalleeModuleName:f(),
    ok.
