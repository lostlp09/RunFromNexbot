local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Teams = game:GetService("Teams")
local Workspace = game:GetService("Workspace")
local gameprocess = {}
gameprocess.players = {} --Players here because i cant find this variable all  the time
local Nextbots = {}
local Survival = {}
local Nextbotplayer = require(ServerStorage.Rojo_Scripts.Nextbots.Nextbotplayer)
local PlayerData = require(ServerStorage.Rojo_Scripts.Playeradded.PlayerData)
local KillTracker = require(script.Parent.KillTracker)
local SurvivorNextbotAlive = require(script.Parent.SurvivorNextbotAlive)
local Maps = game.ReplicatedStorage.Maps
local GameEndsIn = 180
local GameDuration = 180
local GameProcessState = "Waiting"
--local OldMap  ="none"
local GameStartingInSeconds = 15 --if bigger then 15 then it means they are still waiting -if 0 That means The Game Started
gameprocess.gamerunning = false
function gameprocess.wait_for_game()
	if #gameprocess.players <= 1 then
		ReplicatedStorage.Event.CanGameStart:FireAllClients(false)
	end
	repeat
		GameProcessState = "Waiting"
		task.wait()
	until #gameprocess.players > 1
	ReplicatedStorage.Event.CanGameStart:FireAllClients(true, GameStartingInSeconds)
	GameProcessState = "Starting"
	for i = 15, 0, -1 do
		GameStartingInSeconds = i
		if #gameprocess.players <= 1 then
			ReplicatedStorage.Event.CanGameStart:FireAllClients(false)
			GameStartingInSeconds = 15
			task.spawn(function()
				gameprocess.wait_for_game()
			end)
			return
		end
		task.wait(1)
	end
	GameStartingInSeconds = 15
	gameprocess.Startgame()
end
function gameprocess.activate()
	task.spawn(function()
		gameprocess.wait_for_game()
	end)
end
function gameprocess.gameend()
	GameProcessState = "Ended"
	GameEndsIn = 180
	KillTracker.StopKilling()
	Nextbotplayer.RemoveAll()
	if #Survival >= 1 then
		for _, player in Survival do
			PlayerData[player.UserId]["Currency"] += 200
			ReplicatedStorage.Event.Win:FireClient(player, Teams.Survivor)
			game.ReplicatedStorage.Event.GivePlayerCurrentCurrency:FireClient(
				player,
				PlayerData[player.UserId]["Currency"]
			)
		end
	else
		for _, player in Nextbots do
			PlayerData[player.UserId]["Currency"] += 500
			ReplicatedStorage.Event.Win:FireClient(player, Teams.Nextbots)
			game.ReplicatedStorage.Event.GivePlayerCurrentCurrency:FireClient(
				player,
				PlayerData[player.UserId]["Currency"]
			)
		end
	end
	ReplicatedStorage.Event.GameEnded:FireAllClients()

	gameprocess.gamerunning = false
	task.wait(2)
	for _, player: Player in game.Players:GetChildren() do
		if player.Team == Teams.Survivor then
			if player.Character then
				player.Character:PivotTo(
					Workspace:FindFirstChild("Lobby"):FindFirstChild("Spawn").CFrame * CFrame.new(0, 4, 0)
				)
				local Humanoid = player.Character:FindFirstChild("Humanoid")
				if Humanoid then
					Humanoid.WalkSpeed = 16
				end
			end
		end
		player.Team = game.Teams.lobby
	end
	for _, player in Nextbots do
		player.Character:FindFirstChild("Humanoid").Health = 0
	end
	Workspace:FindFirstChild("Map"):Destroy()
	table.clear(Nextbots)
	table.clear(Survival)
	task.spawn(function()
		gameprocess.wait_for_game()
	end)
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
function gameprocess.TeleportPlayers()
	local SpawnLocations = Workspace:FindFirstChild("Map").Spawns:GetChildren()
	local NextbotSpawnLocations = Workspace:FindFirstChild("Map").NextbotSpawn:GetChildren()
	for _, Survivor in Survival do
		local PlayerCharacter = Survivor.Character
		local RandomSpawnIndex = math.random(1, #SpawnLocations)
		local RandomSpawn = SpawnLocations[RandomSpawnIndex]
		table.remove(SpawnLocations, RandomSpawnIndex)
		PlayerCharacter:PivotTo(RandomSpawn.Value)
	end
	for _, Nextbot in Nextbots do
		local PlayerCharacter = Nextbot.Character
		if not PlayerCharacter then
			continue
		end
		local RandomSpawnIndex = math.random(1, #NextbotSpawnLocations)
		local RandomSpawn = NextbotSpawnLocations[RandomSpawnIndex]
		table.remove(NextbotSpawnLocations, RandomSpawnIndex)
		PlayerCharacter:PivotTo(RandomSpawn.Value)
	end

	task.delay(1, function()
		task.spawn(function()
			KillTracker.StartKilling(Nextbots)
		end)
	end)
end
function gameprocess.Startgame()
	while true do
		local OriginalPostion: Vector3 = Maps.OriginalPosition.Value
		local MapArray = Maps:GetChildren()
		local index = math.random(1, #MapArray)

		if MapArray[index]:IsA("Model") then -- and MapArray[index].Name ~= OldMap then
			local SelectedMap: Model = MapArray[index]:Clone()
			SelectedMap.Name = "Map"
			SelectedMap:PivotTo(CFrame.new(OriginalPostion.X, OriginalPostion.Y, OriginalPostion.Z))
			SelectedMap.Parent = game.Workspace
			--OldMap =MapArray[index].Name
			break
		end
	end
	gameprocess.gamerunning = true
	local pickableplayers = {}
	for _, player in gameprocess.players do
		if player.Character then
			table.insert(pickableplayers, player)
		end
	end
	if not (#pickableplayers > 1) then
		task.spawn(function()
			gameprocess.wait_for_game()
		end)
	end
	GameProcessState = "Started"
	for _ = 1, 1, 1 do --1 , math.floor(#pickableplayers/2),  do
		local mathrandom = math.random(1, #pickableplayers)
		local player = pickableplayers[mathrandom]
		player.Team = game.Teams.Nextbots
		gameprocess.makeplayerinv(player)
		table.insert(Nextbots, player)
		table.remove(pickableplayers, mathrandom)
		Nextbotplayer.addplayer(player, PlayerData[player.UserId].NextbotEquiped) --test code because i still dont have a save system
	end
	for _, player: Player in pickableplayers do
		player.Team = game.Teams.Survivor
	end
	Survival = table.clone(pickableplayers)
	SurvivorNextbotAlive.SetNextbot(Nextbots)
	SurvivorNextbotAlive.SetSurvivor(Survival)

	gameprocess.TeleportPlayers()
	ReplicatedStorage.Event.GameStarted:FireAllClients(GameDuration)
	task.spawn(function()
		gameprocess.GameCountDown()
	end)
	game.ReplicatedStorage.Start:Fire()
end
function gameprocess.addplayer(player: Player)
	local Character = player.Character or player.CharacterAdded:Wait()
	local Root = Character:WaitForChild("HumanoidRootPart")
	if Character and Root then
		table.insert(gameprocess.players, player)
		task.wait()
		if GameProcessState == "Waiting" then
			ReplicatedStorage.Event.CanGameStart:FireClient(player, false)
		elseif GameProcessState == "Starting" then
			ReplicatedStorage.Event.CanGameStart:FireClient(player, true, GameStartingInSeconds)
		elseif GameProcessState == "" then
			ReplicatedStorage.Event.GameStarted:FireClient(player, GameEndsIn)
		end
	end
end

function gameprocess.GameCountDown()
	for index = GameDuration, 0, -1 do --300 seconds = 5 min do
		GameEndsIn = index
		task.wait(1)
		if not gameprocess.gamerunning then
			return
		end
	end
	gameprocess.gameend()
end
function gameprocess.removeplayer(player)
	table.remove(gameprocess.players, table.find(gameprocess.players, player))
	gameprocess.playerdied(player, true)
end
function gameprocess.playerdied(player, playerLeft)
	if not gameprocess.gamerunning then
		print("Yooloo")
		return
	end
	if not playerLeft then
		player.Team = Teams.lobby
	end
	local SurvivorIndex = table.find(Survival, player)
	if SurvivorIndex then
		table.remove(Survival, SurvivorIndex)
		SurvivorNextbotAlive.RemoveSurvivor(SurvivorIndex)
		--0
		local GainedTokens = (GameDuration - GameEndsIn) * 0.5
		PlayerData[player.UserId]["Currency"] += GainedTokens
		ReplicatedStorage.Event.Lose:FireClient(player, Teams.Survivor, GainedTokens)
		game.ReplicatedStorage.Event.GivePlayerCurrentCurrency:FireClient(player, PlayerData[player.UserId]["Currency"])
	end
	local NextBotIndex = table.find(Nextbots, player)
	if NextBotIndex then
		table.remove(Nextbots, NextBotIndex)
		SurvivorNextbotAlive.RemoveNextbot(NextBotIndex)
	end
	if #Survival < 1 or #Nextbots < 1 then
		gameprocess.gameend()
	end
end

return gameprocess
