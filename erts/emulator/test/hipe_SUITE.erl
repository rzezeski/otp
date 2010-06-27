-module(hipe_SUITE).

-include("test_server.hrl").

-export([all/1,call_beam_module_with_on_load/1]).

all(suite) ->
    [call_beam_module_with_on_load].

call_beam_module_with_on_load(suite) ->
    [];
call_beam_module_with_on_load(doc) ->
    ["Test that we can call a non-native module with a on_load from a native module"];
call_beam_module_with_on_load(Config) when is_list(Config) ->
    ?line DataDir = ?config(data_dir, Config),
    ?line CallerModule = filename:join(DataDir, "native_caller.erl"),
    ?line CalleeModule = filename:join(DataDir, "beam_callee.erl"),
    ?line PrivDir = ?config(priv_dir, Config),
    test_call_with_on_load(PrivDir, CallerModule, CalleeModule).

test_call_with_on_load(PrivDir, CallerModule, CalleeModule) ->
    % Compile both modules.
    ?line {ok, CallerModuleName} = compile:file(CallerModule, [{outdir, PrivDir}]),
    ?line {ok, CalleeModuleName} = compile:file(CalleeModule, [{outdir, PrivDir}]),
    % Add PrivDir to the path so we can load modules interactively.
    AbsPrivDir = filename:absname(PrivDir),
    ?line true = code:add_patha(AbsPrivDir),
    % Call the function in caller module.
    ?line ok = CallerModuleName:call(CalleeModuleName),
    % Purge both modules now.
    ?line true = code:soft_purge(CallerModuleName),
    ?line true = code:soft_purge(CalleeModuleName),
    % Remove PrivDir from the path.
    ?line true = code:del_path(AbsPrivDir),
    ok.
