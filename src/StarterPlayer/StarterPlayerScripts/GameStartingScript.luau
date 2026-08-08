local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Teams = game:GetService("Teams")
local InventoryUi = require(StarterPlayer.StarterPlayerScripts.Rojo_Scripts.Ui.InventoryUi)
local ShopUi = require(StarterPlayer.StarterPlayerScripts.Rojo_Scripts.Ui.ShopUi)
local TextAnnoucments = require(StarterPlayer.StarterPlayerScripts.Rojo_Scripts.Ui.TextAnnoucments)
local EmoteScript = require(script.Parent.EmoteScript)
local MakeJumpButtonVisible = require(script.Parent.MakeJumpButtonVisible)
local module = {}
local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")
local LobbyScreenGui = player.PlayerGui:WaitForChild("LobbyGui")
local CanGameStart = game.ReplicatedStorage.Event:WaitForChild("CanGameStart")
print("ICH WURDE REQUIRED")
function module.GameEnded(DeleteTimer: boolean)
	if MakeJumpButtonVisible.isOnMobile then
		MakeJumpButtonVisible.TurnSprintButton(true)
	end
	for _, ui in player.PlayerGui:WaitForChild("LobbyGui"):GetChildren() do
		ui.Visible = false
	end
	if DeleteTimer then
		print("Todo")
	end
end

Humanoid.Died:Connect(function()
	module.GameEnded(false)
end)

local function TurnLobbyUi(bool: boolean)
	for _, ui in player.PlayerGui:WaitForChild("LobbyGui"):GetChildren() do
		ui.Visible = bool
	end
end
function module.GameStarting(Time)
	TextAnnoucments:RoundCountdown(Time)
	ReplicatedStorage.Event:WaitForChild("GameEnded").OnClientEvent:Connect(function()
		module.GameEnded(true)
	end)
	if player.Team == Teams.lobby then
		return
	elseif player.Team == Teams.Nextbots then
		EmoteScript.WheelOnOrOFF(false)
		if MakeJumpButtonVisible.isOnMobile() then
			MakeJumpButtonVisible.TurnSprintButton(false)
		end
		TurnLobbyUi(false)
	end
	ShopUi.DisableUi()
	InventoryUi.Disable()
end
ReplicatedStorage.Event:WaitForChild("GameStarted").OnClientEvent:Connect(function(Time)
	module.GameStarting(Time)
end)
CanGameStart.OnClientEvent:Connect(function(CanStart: boolean, Time)
	if CanStart then
		TextAnnoucments:GameCanStartInCD(Time)
	else
		TextAnnoucments.WaitForPlayers()
	end
end)

return module
