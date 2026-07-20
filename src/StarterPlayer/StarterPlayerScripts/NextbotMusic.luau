local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundCreator = require(ReplicatedStorage.Shared.SoundCreator)

local NextBotMusic = {}

game.ReplicatedStorage.Event.SoundPlayer.AddFollowMusic.OnClientEvent:Connect(function(EnemyPlayerId: number, SongID)
	local SoundBlock = SoundCreator.newFollwingSound(SongID, EnemyPlayerId, -1, 1, true)
	SoundBlock.Name = "FollowMusic"
end)

game.ReplicatedStorage.Event.SoundPlayer.ChangeFollowingMusic.OnClientEvent:Connect(function(UserID, SongID, duration)
	local Enemyplayer: Player = Players:GetPlayerByUserId(UserID)
	local Character = Enemyplayer.Character
	local FollowMusic = Character:FindFirstChild("FollowMusic")
	if not FollowMusic then
		return
	end
	local Sound: Sound = FollowMusic:FindFirstChild("Sound")
	local oldid = Sound.SoundId
	Sound:Stop()
	Sound.SoundId = SongID
	Sound:Play()
	print("Changed audio")
	task.wait(duration)
	Sound:Stop()
	Sound.SoundId = oldid
	Sound:Play()
end)

return NextBotMusic
