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
local GameStartGui = LobbyScreenGui:WaitForChild("GameUi")
local CanGameStart = game.ReplicatedStorage.Event:WaitForChild("CanGameStart")
local GameStarted = false
print("ICH WURDE REQUIRED")

local function TurnLobbyUi(bool: boolean)
	for _, ui in player.PlayerGui:WaitForChild("LobbyGui").Frame:GetChildren() do
		if ui:IsA("GuiButton") or ui.Name == "Currency" then
			ui.Visible = bool
		end
	end
end
function module.activate()
	ReplicatedStorage.Event:WaitForChild("GameEnded").OnClientEvent:Connect(function()
		module.GameEnded(true)
	end)
end
function module.GameEnded(DeleteTimer: boolean)
	TurnLobbyUi(true)
	MakeJumpButtonVisible.TurnMovmentButtons(false)
	if DeleteTimer then
		print("Todo")
	end
end
Humanoid.Died:Connect(function()
	module.GameEnded(false)
end)
function module.GameStarting(Time)
	TextAnnoucments:RoundCountdown(Time)
	TurnLobbyUi(false)
	if player.Team == Teams.lobby then
		return
	elseif player.Team == Teams.Survivor then
		MakeJumpButtonVisible.TurnMovmentButtons(true)
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
