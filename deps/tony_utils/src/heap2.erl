-module (heap2).
-export([empty/0,is_empty/1,insert/2,hget/1,test/0]).

empty() ->
    nil.

%-spec is_empty(State) -> boolean().
is_empty(nil) ->
    true;
is_empty(_) ->
    false.

%-spec hget(State) -> {Result:any(),NewState:state()}.
hget({Root,nil,nil}) ->
    {Root,nil};
hget({Smallest,nil,Larger}) ->
    {Smallest,{Larger,nil,nil}};
hget({S,L,nil}) ->
    {S,{L,nil,nil}};
hget({S,T1,T2}) ->
    Smallest = S,
    T1Small = root(T1),
    T2Small = root(T2),
    {SHeap,LHeap} =
	case T1Small < T2Small of
	    true ->
		{T1,T2};
	    false ->
		{T2,T1}
	    end,
    {Small,RemHeap} = hget(SHeap),
    {Smallest,{Small,RemHeap,LHeap}};
hget(X) -> 
    {X,nil}.


root({S,_,_}) ->
    S;
root(Z) -> 
    Z.

    
insert(Value,nil) ->
    {Value,nil,nil};
insert(Value,{X,nil,nil}) when Value < X ->
    {Value,X,nil};
insert(Value,{X,nil,nil}) when X =< Value ->
    {X,Value,nil};
insert(Value,{X,A,nil}) when Value < X  ->
    {Value,A,X};
insert(Value,{X,A,nil}) ->
    {X,A,Value};
insert(Value,{X,nil,A}) when Value < X  ->
    {Value,{A,X}};
insert(Value,{X,nil,A}) ->
    {X,Value,A};
insert(Value,{X,A,B}) when Value < X and is_tuple(A) ->
    {Value,B,insert(X,A)};
insert(Value,{X,A,B})  when X=<Value and is_tuple(A)->
    {X,B,insert(Value,A)};
insert(Value,{X,A,B}) when Value < X ->
    {Value,B,val_insert(X,A)};
insert(Value,{X,A,B}) ->
    {X,B,val_insert(Value,A)}.

val_insert(A,B) when A<B ->
    {A,B,nil};
val_insert(A,B) ->
    {B,A,nil}.



test() ->
    true = is_empty(empty()),
    false = is_empty(insert(1,empty())),
    {1,Empty} = hget(insert(1,empty())),
    true = is_empty(Empty),
    A = [1,2,3],
    Permutations = cartesian:product([A,A,A]),
    [test_perm(L) || L <- Permutations],
    B = [1,2,3,4],
    P2 = cartesian:product([B,B,B,B,B]),
    [test_perm(L) || L <- P2].
    
test_perm(L) ->
    io:format("testing permutation ~p~n",[L]),
    Result = list_in_order(process_list(L)),
    check_result(L,Result).

process_list(L) ->
    get_data(make_heap(L),[]).

make_heap(L) ->
    lists:foldl(fun(X,A) ->  insert(X,A) end,empty(),L).

get_data(Heap,Acc) ->
    case is_empty(Heap) of
	true ->
	    lists:reverse(Acc);
	false ->
	    {Data,NewHeap} = hget(Heap),
	    get_data(NewHeap,[Data|Acc])
    end.

list_in_order(L) ->
    list_in_order(L,true).
list_in_order(_,false) ->
    false;
list_in_order([A,B|[]],true) ->
    A =< B;
list_in_order([Front,Next|Rest],true) -> 
    list_in_order([Next|Rest],Front =< Next).

check_result(L,false) ->
    io:format("heap2 test failed with permutation ~p~n",[L]),
    H = make_heap(L),
    io:format("heap created was ~p~n",[H]),
    R = get_data(H,[]),
    io:format("result list was ~p~n~n",[R]);

check_result(_,true) ->
    ok.
