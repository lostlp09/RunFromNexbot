local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Text = ReplicatedStorage.Ui:WaitForChild("Texts").TextAnnoucment
local player = Players.LocalPlayer
local LobbyGui = player.PlayerGui:WaitForChild("LobbyGui")
local module = {}
local GameStarted = ReplicatedStorage.Event.GameStarted
local GameEnded = ReplicatedStorage.Event.GameEnded
local CanGameStart = ReplicatedStorage.Event.CanGameStart
function module.CreateText()
	local Object = Text:Clone()
	Object.Parent = LobbyGui
	return Object
end
function module.CountDown(TextObject: TextLabel, Time: number, Event)
	local Connection

	Connection = Event.OnClientEvent:Connect(function(boolean)
		print("Ich wurde Abgefeuert", Time)
		if boolean == true or boolean == nil then
			TextObject:Destroy()
			Connection:Disconnect()
			return
		end
	end)
	for CurrentTime = Time, 0, -1 do
		local TimeInFormat = string.format("%02d:%02d", math.floor(CurrentTime / 60), CurrentTime % 60)
		if not TextObject.Parent then
			break
		end
		TextObject.Text = TimeInFormat
		if CurrentTime == 0 then
			task.wait(1)
			TextObject:Destroy()
			if Connection then
				Connection:Disconnect()
			end
		end
		task.wait(1)
	end
end
function module.LoadingText(TextObject: TextLabel)
	local index = 1
	local Connection
	local AllowToloop = true
	Connection = CanGameStart.OnClientEvent:Connect(function(boolean)
		if boolean then
			TextObject:Destroy()
			AllowToloop = false
			Connection:Disconnect()
		end
	end)
	while AllowToloop do
		task.wait(1)
		index += 1
		if index > 3 then
			index = 0
		end
		if TextObject.Parent ~= nil then
			TextObject.Text = "Waiting for players" .. string.rep(".", index)
		else
			if Connection then
				Connection:Disconnect()
			end
			break
		end
	end
end
function module.WaitForPlayers()
	if LobbyGui:FindFirstChild("WaitForPlayers") then
		return
	end
	local TextObject: TextLabel = module.CreateText()
	TextObject.Name = "WaitForPlayers"
	TextObject.Text = "Waiting for players."
	task.spawn(function()
		print("yo im getting runned")
		module.LoadingText(TextObject)
	end)
end
function module:RoundCountdown(Time)
	if LobbyGui:FindFirstChild("GameCountDown") then
		return
	end
	if LobbyGui:FindFirstChild("GameStartsInCD") then
		LobbyGui:FindFirstChild("GameStartsInCD").Visible = false
	end
	local TextObject = self.CreateText()
	TextObject.Name = "GameCountDown"
	task.spawn(function()
		self.CountDown(TextObject, Time, GameEnded)
	end)
end
function module:GameCanStartInCD(Time)
	if LobbyGui:FindFirstChild("GameCanStartInCD") then
		return
	end
	local TextObject = self.CreateText()
	TextObject.Name = "GameCanStartInCD"
	task.spawn(function()
		self.CountDown(TextObject, Time, CanGameStart)
	end)
end

return module
