local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundCreator = require(ReplicatedStorage.Shared.SoundCreator)

ReplicatedStorage.Event:FindFirstChild("SoundPlayer").PlaySound.OnClientEvent:Connect(function(Id, PositionOrUserId)
	task.spawn(SoundCreator.States[Id], PositionOrUserId)
end)
ReplicatedStorage.Event:FindFirstChild("SoundPlayer").PlayEmoteAudio.OnClientEvent:Connect(function(EmoteKey, id)
	local Player = Players:GetPlayerByUserId(id)
	local Root = Player.Character:FindFirstChild("HumanoidRootPart")
	local EmoteBlock = Root:FindFirstChild("EmoteBlock")
	if not Root or not EmoteBlock then
		return
		---TODO CHANGE VOLUME TO PLAYER SETTINGS CLient Sided so i dont always need to update the player settings date .
	end
end)
