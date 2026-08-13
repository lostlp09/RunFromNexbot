local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundCreator = require(ReplicatedStorage.Shared.SoundCreator)

local NextBotMusic = {}

function NextBotMusic.activate()
	game.ReplicatedStorage.Event
		:WaitForChild("SoundPlayer")
		:WaitForChild("AddNextbotMusic").OnClientEvent
		:Connect(function(EnemyPlayerId)
			if Players.LocalPlayer.UserId == EnemyPlayerId then
				local object =
					Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"):WaitForChild("FollowMusic")

				if object then
					object.Sound.Volume = 0
				end
			end
		end)
end

return NextBotMusic
