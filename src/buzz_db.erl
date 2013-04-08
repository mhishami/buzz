-module (buzz_db).
-author ('Hisham Ismail <mhishami@gmail.com>').

-include ("buzz.hrl").
-include_lib("mongrel/include/mongrel_macros.hrl").

-define (HOST, localhost).
-define (DB, buzz).

-export ([authenticate/2, register/2]).
-export ([add_mappings/0]).

add_mappings() ->
    ?add_mapping(user),
    ?add_mapping(profile),
    ?add_mapping(post),
    ?add_mapping(group).
    
%% ------------------------------------------------
%% user
%%
register(User, Profile) ->
    {ok, Conn} = mongo:connect(?HOST),
    mongrel:do(safe, master, Conn, ?DB,
        fun() ->
            mongrel:insert(User),
            mongrel:insert(Profile)
        end),
    mongo:disconnect(Conn).
        
authenticate(Email, Password) ->
    {ok, Conn} = mongo:connect(?HOST),
    F = fun() ->
            mongrel:find_one(#user{ email = Email, password = Password })
        end,
    case catch mongrel:do(safe, master, Conn, ?DB, F) of
        {ok, _} -> ok;
        _ -> error
    end,
    mongo:disconnect(Conn).
    