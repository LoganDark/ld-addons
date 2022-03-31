-- net event names as string for easy maintenance, for whatever reason
local NET_JOIN    = 'LDPlayerJoin'
local NET_LOADED  = 'LDPlayerLoaded'
local NET_LEFT    = 'LDPlayerLeft'
local NET_NOTDEDI = 'LDPlayerJLNotDedi'

if SERVER then
	-- register all of these on both client and server
	util.AddNetworkString(NET_JOIN)
	util.AddNetworkString(NET_LOADED)
	util.AddNetworkString(NET_LEFT)
	util.AddNetworkString(NET_NOTDEDI)

	gameevent.Listen('player_connect')
	gameevent.Listen('player_disconnect')

	-- only add a server-side hook if this is a dedicated server, else tell the
	-- clients to add a client-side hook
	if game.IsDedicated() then
		hook.Add('player_connect', NET_JOIN, function(data)
			net.Start(NET_JOIN)
			net.WriteString(data.name)
			net.WriteString(data.networkid)
			net.Send(player.GetHumans())
		end)
	else
		net.Start(NET_NOTDEDI)
		net.Send(player.GetHumans())
	end

	-- prevent the client from spamming the chat with tons of NET_LOADED events
	-- by only allowing them to load once
	local alreadyLoaded = {}

	net.Receive(NET_LOADED, function(len, ply)
		local userid = ply:UserID()

		if !alreadyLoaded[userid] then
			alreadyLoaded[userid] = true

			net.Start(NET_LOADED)
			net.WriteEntity(ply)
			net.WriteString(ply:SteamID())
			net.Send(player.GetHumans())

			-- if the server isn't dedicated, tell the new player to add
			-- their own player_connect hook
			if !game.IsDedicated() then
				net.Start(NET_NOTDEDI)
				net.Send(ply)
			end
		end
	end)

	hook.Add('player_disconnect', NET_LEFT, function(data)
		alreadyLoaded[data.userid] = nil

		net.Start(NET_LEFT)
		net.WriteString(data.name)
		net.WriteString(data.networkid)
		net.Send(player.GetHumans())
	end)
end

if CLIENT then
	local LOG_COLOR     = Color(0, 255, 255)
	local GOOD_COLOR    = Color(0, 255, 0)
	local STEAMID_COLOR = Color(255, 255, 255)

	function logJoin(username, steamid)
		chat.AddText(
			GOOD_COLOR,
			username,
			LOG_COLOR,
			' [',
			STEAMID_COLOR,
			steamid,
			LOG_COLOR,
			'] is connecting to the server...'
		)
	end

	function logLoaded(player, steamid)
		chat.AddText(
			GOOD_COLOR,
			player,
			LOG_COLOR,
			' [',
			STEAMID_COLOR,
			steamid,
			LOG_COLOR,
			'] has ',
			GOOD_COLOR,
			'fully connected',
			LOG_COLOR,
			' to the server.'
		)
	end

	function logLeft(username, steamid)
		chat.AddText(
			GOOD_COLOR,
			username,
			LOG_COLOR,
			' [',
			STEAMID_COLOR,
			steamid,
			LOG_COLOR,
			'] has left the game.'
		)
	end

	-- this sends an event to the server as soon as the client loads
	timer.Simple(0, function() net.Start(NET_LOADED) net.SendToServer() end)

	net.Receive(NET_JOIN,   function() logJoin  (net.ReadString(), net.ReadString()) end)
	net.Receive(NET_LOADED, function() logLoaded(net.ReadEntity(), net.ReadString()) end)
	net.Receive(NET_LEFT,   function() logLeft  (net.ReadString(), net.ReadString()) end)

	net.Receive(NET_NOTDEDI, function()
		-- player_connect isn't called server-side on non-dedicated servers
		gameevent.Listen('player_connect')

		hook.Add('player_connect', NET_JOIN, function(data) logJoin(data.name, data.networkid) end)
	end)
end
