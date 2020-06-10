%%% -------------------------------------------------------------------
%%% @author  : uabjle
%%% @doc : support functions boot_service
%%% -------------------------------------------------------------------
-module(local_dns).
  


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------

%% External exports
-export([init/0,
	 update/1,
	 get/1,
	 all/0
	]).
	 


%% ====================================================================
%% External functions
%% ====================================================================
init()->
    ?MODULE=ets:new(?MODULE,[named_table,set,public,{read_concurrency,true}]),
    true=ets:insert(?MODULE,{list,[]}),
    ok.

update(DnsInfo)->
    true=ets:insert(?MODULE,{list,DnsInfo}),
    ok.

get(Wanted_ServiceId)->
   R=case ets:tab2list(?MODULE) of
	 [{list,[]}]->
	     [];
	 [{list,DnsInfo}]->
	     [{ServiceId,Node}||{ServiceId,Node}<-DnsInfo,
				Wanted_ServiceId==ServiceId]
     end,
    R.

all()->
    [{list,DnsInfo}]=ets:tab2list(?MODULE),
    DnsInfo.
