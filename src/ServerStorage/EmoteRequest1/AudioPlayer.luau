local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EmotePlayer = require(ReplicatedStorage.Shared.EmotePlayer.EmotePlayer)
local SoundCreator = require(ReplicatedStorage.Shared.SoundCreator)
local module = {}
local PlayAudioEvent: RemoteEvent =
	game.ReplicatedStorage.Event:FindFirstChild("SoundPlayer"):FindFirstChild("PlayEmoteAudio")
function module.PlayAudio(key, player)
	print("I Got Runned")
	local Root = player.Character:FindFirstChild("HumanoidRootPart")
	local SoundBlock = SoundCreator.new("rbxassetid://" .. EmotePlayer.EmoteAudio[key], Root.Position, 1, true)
	SoundBlock.Parent = Root
	SoundBlock.Name = "EmoteBlock"
	SoundBlock:FindFirstChild("Sound").Looped = true
	game.ReplicatedStorage.Event.SoundPlayer.PlayEmoteAudio:FireAllClients(key, player.UserId)
end

return module
