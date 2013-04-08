
-define (INFO(Name), lager:log(info, self(), Name)).
-define (INFO(Name, Args), lager:log(info, self(), Name, Args)).
-define (DEBUG(Name), lager:log(debug, self(), Name)).
-define (DEBUG(Name, Args), lager:log(debug, self(), Name, Args)).

-define (b2i(Val), list_to_integer(binary_to_list(Val))).

%% records
%       +------+        +-------+
%       |      |        |       |
%       | User +-------<| Group +---+
%       |      |        |       |   |
%       +-+--+-+        +----+--+   |
%         |  |                      |
%         |  +-------+              |
%       +-+-------+  |  +------+    |
%       |         |  |  |      |    |
%       | Profile |  +-<| Post |>---+
%       |         |     |      |
%       +---------+     +------+
%
-record(user, {'_id', email, password, join_date, update_date, groups}).
-record(profile, {'_id', email, first_name, last_name, mobile_no, birthdate, avatar}).
-record(post, {'_id', group, author, post, posted_date, update_date}).
-record(group, {'_id', admin, desc, members}).
