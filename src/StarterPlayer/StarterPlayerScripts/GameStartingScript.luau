local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local StarterPlayer = game:GetService("StarterPlayer")
local Teams = game:GetService("Teams")
local MusicChaseTracker = require(ReplicatedStorage.Shared.MusicChaseTracker)
local InventoryUi = require(StarterPlayer.StarterPlayerScripts.Rojo_Scripts.Ui.InventoryUi)
local ShopUi = require(StarterPlayer.StarterPlayerScripts.Rojo_Scripts.Ui.ShopUi)
local TextAnnoucments = require(StarterPlayer.StarterPlayerScripts.Rojo_Scripts.Ui.TextAnnoucments)
local EmoteScript = require(script.Parent.EmoteScript)
local MakeJumpButtonVisible = require(script.Parent.MakeJumpButtonVisible)
local module = {}
local player = Players.LocalPlayer
local Character = player.Character
local InGameMusic = "rbxassetid://81154452186957"

local CanGameStart = game.ReplicatedStorage.Event:WaitForChild("CanGameStart")

local BackGroundMusic = "rbxassetid://80849508346318"
local BackGroundMusicPlayer: Sound = SoundService:FindFirstChild("BackGroundMusic")

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
		EmoteScript.IsInGame = false
	end)
	ReplicatedStorage.Event:WaitForChild("GameStarted").OnClientEvent:Connect(function(Time)
		EmoteScript.IsInGame = true
		module.GameStarting(Time)
	end)
end
function module.GameEnded(DeleteTimer: boolean)
	TurnLobbyUi(true)
	BackGroundMusicPlayer.SoundId = BackGroundMusic
	BackGroundMusicPlayer:Play()
	MakeJumpButtonVisible.TurnMovmentButtons(false)
	if DeleteTimer then
		print("Todo")
	end
end
if Character then
	local Humanoid: Humanoid = Character:WaitForChild("Humanoid")
	Humanoid.Died:Connect(function()
		module.GameEnded(false)
		EmoteScript.IsInGame = false
	end)
end

player.CharacterAdded:Connect(function(Character1)
	local Humanoid = Character1:WaitForChild("Humanoid")
	Humanoid.Died:Connect(function()
		module.GameEnded(false)
		EmoteScript.IsInGame = false
	end)
end)

function module.GameStarting(Time)
	BackGroundMusicPlayer.SoundId = InGameMusic
	BackGroundMusicPlayer:Play()
	TextAnnoucments:RoundCountdown(Time)
	TurnLobbyUi(false)
	EmoteScript.WheelOnOrOFF(false)
	if player.Team == Teams.lobby then
		return
	elseif player.Team == Teams.Survivor then
		MakeJumpButtonVisible.TurnMovmentButtons(true)
		MusicChaseTracker.instantiate()
	end
	ShopUi.DisableUi()
	InventoryUi.Disable()
end

CanGameStart.OnClientEvent:Connect(function(CanStart: boolean, Time)
	if CanStart then
		TextAnnoucments:GameCanStartInCD(Time)
	else
		print("Test")
		TextAnnoucments.WaitForPlayers()
	end
end)

return module
