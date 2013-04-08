-module (auth_handler).

-include ("buzz.hrl").

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
	{ok, Req, undefined}.

handle(Req, State) ->
    ?INFO("State = ~p~n", [State]),
    
	{Method, Req2} = cowboy_req:method(Req),
	{[Path], Req3} = cowboy_req:path_info(Req2),
    
	{ok, Req4} = auth(Method, Path, Req3),
	{ok, Req4, State}.

auth(<<"GET">>, <<"login">>, Req) ->
    {ok, Content} = login_dtl:render([]),
	cowboy_req:reply(200, [], Content, Req);

auth(<<"POST">>, <<"login">>, Req) ->
    %% process login
    
    %% redirect to home
    cowboy_req:reply(302, [{<<"Location">>, <<"/">>}], [], Req);
    
auth(_, _, Req) ->
	%% Method not allowed.
	cowboy_req:reply(405, Req).

terminate(_Reason, _Req, _State) ->
	ok.
