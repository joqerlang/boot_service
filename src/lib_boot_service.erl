%%% -------------------------------------------------------------------
%%% @author  : uabjle
%%% @doc : support functions boot_service
%%% -------------------------------------------------------------------
-module(lib_boot_service).
  


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
%% --------------------------------------------------------------------

%% External exports
-export([connect_catalog/3
	]).
	 


%% ====================================================================
%% External functions
%% ====================================================================
connect_catalog(DnsInfo,NumTries,Interval)->
    try_connect(DnsInfo,NumTries,Interval,start).

try_connect(_,_,_,ok)->
    ok;
try_connect(_,0,_,R)->
    R;
try_connect(DnsInfo,NumTries,Interval,_)->
    R=case connect(DnsInfo,start) of
	  ok->
	      ok;
	  _->
	      timer:sleep(Interval),
	      error
      end,
    try_connect(DnsInfo,NumTries-1,Interval,R). 
    
connect(_,ok)->
    ok;
connect([],R)->
    R;
connect([{Node}|T],_)->
    R=case rpc:call(Node,catalog_service,ping,[],5000) of
	  {pong,Node,catalog_service}->
	      ok;
	  Err ->
	      {error,Err}
      end,
    connect(T,R).
							    
  




%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------

