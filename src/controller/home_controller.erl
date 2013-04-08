-module (home_controller).

-export ([handle_request/5]).
-export ([before_filter/2]).

before_filter(_Params, _Req) ->
    {ok, proceed}.
    
handle_request(<<"GET">>, Action, _Args, [Auth, _, _, _], _Req) ->
    {Action, [Auth]};
    
handle_request(_, _, _, _, _) ->
    {error, <<"Ops!">>}.
    