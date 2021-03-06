-module(channel_latestnews_handler).
-author("chanakyam@koderoom.com").

-export([init/3]).

-export([content_types_provided/2]).
-export([welcome/2]).
-export([terminate/3]).

%% Init
init(_Transport, _Req, []) ->
	{upgrade, protocol, cowboy_rest}.

%% Callbacks
content_types_provided(Req, State) ->
	{[		
		{<<"text/html">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->
	{Limit, _ } = cowboy_req:qs_val(<<"l">>, Req),
	Url = string:concat("http://api.contentapi.ws/news?channel=fashion&skip=0&format=short&limit=",Limit),
	% Url = "http://api.contentapi.ws/news?channel=fashion&limit=4&skip=0&format=short",
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	Body = list_to_binary(Response_mlb),
	{Body, Req, State}.

