-module (buzz_model).
-author ('Hisham Ismail <mhishami@gmail.com>').

-include ("buzz.hrl").
-include_lib("mongrel/include/mongrel_macros.hrl").

-export ([authenticate/2]).
-export ([add_mappings/0]).

add_mappings() ->
    ?add_mapping(user),
    ?add_mapping(profile),
    ?add_mapping(post),
    ?add_mapping(group).
    
authenticate(Email, Password) ->
    case Email =:= <<"mhishami@gmail.com">> andalso
        Password =:= <<"sa">> of
        true ->
            ok;
        _ ->
            error
    end.
    