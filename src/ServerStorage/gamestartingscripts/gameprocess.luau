local ServerStorage = game:GetService("ServerStorage")
local gameprocess = {}
gameprocess.players = {} --Players here because i cant find this variable all  the time
local Nextbots = {}
local Survival = {}
local Nextbotplayer = require(ServerStorage.Rojo_Scripts.Nextbots.Nextbotplayer)
local KillTracker = require(script.Parent.KillTracker)
local SurvivorNextbotAlive = require(script.Parent.SurvivorNextbotAlive)

gameprocess.gamerunning = false
function gameprocess.wait_for_game()
	repeat
		task.wait(1)
	until #gameprocess.players > 1

	print("enough players")
	task.wait(10)
	gameprocess.Startgame()
end
function gameprocess.activate()
	task.spawn(function()
		gameprocess.wait_for_game()
	end)
end
function gameprocess.gameend()
	KillTracker.StopKilling()

	gameprocess.gamerunning = false
	print(gameprocess.players)
	for _, player: Player in game.Players:GetChildren() do
		player.Team = game.Teams.lobby
	end
	task.wait(3)
	for _, player in Nextbots do
		player.Character.Rojo_Scripts.othermovment.Enabled = true
		player.Character:FindFirstChild("Humanoid").Health = 0
	end

	table.clear(Nextbots)
	table.clear(Survival)
	Nextbotplayer.RemoveAll()
	gameprocess.wait_for_game()
end

function gameprocess.makeplayerinv(player)
	local Invisiblecostumes = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
	repeat
		task.wait()
	until player.Character ~= nil
	for _, part in player.Character:GetChildren() do
		if part:IsA("Accessory") then
			part:Destroy()
		elseif table.find(Invisiblecostumes, part.Name) ~= nil then
			part.Transparency = 1
		end
	end
end
function gameprocess.Startgame()
	gameprocess.gamerunning = true
	local pickableplayers = table.clone(gameprocess.players)

	print(pickableplayers)
	for i = 1, 1, 1 do --1 , math.floor(#pickableplayers/2),  do
		print(i)
		local mathrandom = math.random(1, #pickableplayers)
		local player: Player = pickableplayers[mathrandom]
		print(player)
		player.Team = game.Teams.Nextbots
		local PlayerGui = player.PlayerGui
		PlayerGui:FindFirstChild("Emote").EmoteScript.Enabled = false
		gameprocess.makeplayerinv(player)

		table.insert(Nextbots, player)
		table.remove(pickableplayers, mathrandom)
		local Character = player.Character
		Character.Rojo_Scripts:FindFirstChild("othermovment").Enabled = false
		game.ReplicatedStorage.localnextbotevents.ResetCamerOffset:FireClient(player)
		Nextbotplayer.addplayer(player, "Sanic") --test code because i still dont have a save system
		game.ReplicatedStorage.playeranimation.disableanimation:FireClient(player)
	end

	task.spawn(function()
		KillTracker.StartKilling(Nextbots)
	end)

	game.ReplicatedStorage.Start:Fire()
	print(pickableplayers)
	for _, player: Player in pickableplayers do
		player.Team = game.Teams.Survivor
	end
	Survival = table.clone(pickableplayers)
	SurvivorNextbotAlive.SetNextbot(Nextbots)
	SurvivorNextbotAlive.SetSurvivor(Survival)
end

function gameprocess.addplayer(player: Player)
	player.Team = game.Teams.Survivor
	table.insert(gameprocess.players, player)
	print(gameprocess.players)
end
function gameprocess.removeplayer(player)
	table.remove(gameprocess.players, table.find(gameprocess.players, player))
	gameprocess.playerdied(player)
end
function gameprocess.playerdied(player: Player)
	print("doesthefubnction even run")
	print("Survivors", Survival)
	if not gameprocess.gamerunning then
		return
	end

	for i, value in Survival do
		if value == player then
			table.remove(Survival, i)
			break
		end
	end
	for i, value in Nextbots do
		if value == player then
			table.remove(Nextbots, i)
			break
		end
	end
	print(#Survival)
	print(#Nextbots)
	if #Survival < 1 or #Nextbots < 1 then
		print("game_end")
		gameprocess.gameend()
		return
	end
end

return gameprocess
