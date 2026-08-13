local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundCreator = require(ReplicatedStorage.Shared.SoundCreator)

local NextBotMusic = {}

function NextBotMusic.activate()
	game.ReplicatedStorage.Event.SoundPlayer.AddFollowMusic.OnClientEvent:Connect(
		function(EnemyPlayerId: number, SongID)
			if Players.LocalPlayer.UserId == EnemyPlayerId then
				return
			end
			print("Erstelle SoundBlock")
			local SoundBlock = SoundCreator.newFollwingSound(SongID, EnemyPlayerId, -1, 1, true)
			SoundBlock.Name = "FollowMusic"
		end
	)

	game.ReplicatedStorage.Event.SoundPlayer.ChangeFollowingMusic.OnClientEvent:Connect(
		function(UserID, SongID, duration)
			local Enemyplayer: Player = Players:GetPlayerByUserId(UserID)
			local Character = Enemyplayer.Character
			local Root = Character:FindFirstChild("HumanoidRootPart")
			local FollowMusic = Root:FindFirstChild("FollowMusic")
			if not FollowMusic then
				print("no Block Found")
				return
			end
			local Sound: Sound = FollowMusic:FindFirstChild("Sound")
			local oldid = Sound.SoundId
			print(SongID, oldid)
			Sound:Stop()
			Sound.SoundId = SongID
			Sound:Play()
			print("Changed audio")
			task.wait(duration)
			Sound:Stop()
			Sound.SoundId = oldid
			Sound:Play()
		end
	)
end

return NextBotMusic
