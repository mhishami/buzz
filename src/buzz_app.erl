-module(buzz_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    % Dispatch = cowboy_router:compile([
    %     {'_', [
    %         {"/", home_handler, []},
    %         {"/auth/login", auth_handler, []},
    %         {"/auth/register", auth_handler, []},
    %         {"/static/[...]", cowboy_static, [
    %             {directory, {priv_dir, buzz, [<<"assets">>]}},
    %             {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
    %         ]}             
    %     ]}
    % ]),
    %     {ok, _} = cowboy:start_https(https, 100, [
    %         {port, 8443},
    %         {cacertfile, "priv/ssl/cowboy-ca.crt"},
    %         {certfile, "priv/ssl/server.crt"},
    %         {keyfile, "priv/ssl/server.key"}], [
    %         {env, [{dispatch, Dispatch}]}
    %     ]),
    %     
    % {ok, _} = cowboy:start_http(http, 100, [
    %         {port, 8080}], [
    %         {env, [{dispatch, Dispatch}]}
    %     ]),
    
    lager:start(),
    buzz_db:add_mappings(),
    buzz_sup:start_link().

stop(_State) ->
    ok.
