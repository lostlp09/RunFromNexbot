local SoundCreator = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local EmotePlayer = require(ReplicatedStorage.Shared.EmotePlayer.EmotePlayer)
function SoundCreator.ChangeFollowingMusic(UserID, SongID, duration)
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
function SoundCreator.new(Id, position: Vector3, speed, returnable)
	local SoundBlock = ReplicatedStorage.Event:FindFirstChild("SoundPlayer").SoundBlock:Clone()
	SoundBlock.Parent = game.Workspace
	SoundBlock.Position = position
	local Sound: Sound = SoundBlock:FindFirstChild("Sound")
	Sound.SoundId = Id
	Sound:Play()
	if not returnable then
		Sound.Ended:Wait()
		SoundBlock:Destroy()
		return nil
	else
		return SoundBlock
	end

	return SoundBlock
end
function SoundCreator.newFollwingSound(Id, UserId: number, duration: number, speed: number, returnable: boolean)
	local SoundBlock = ReplicatedStorage.Event:FindFirstChild("SoundPlayer").FollowingSoundBlock:Clone()
	SoundBlock.Name = "FollowMusic"
	SoundBlock.Anchored = false
	local Player = Players:GetPlayerByUserId(UserId)
	local Character = Player.Character
	if not Character then
		return
	end
	local root = Character:FindFirstChild("HumanoidRootPart")
	local position = root.Position
	SoundBlock.Position = position
	local WeldConstraint: WeldConstraint = SoundBlock:FindFirstChild("WeldConstraint")
	WeldConstraint.Part1 = root
	SoundBlock.Parent = root
	local Sound: Sound = SoundBlock:FindFirstChild("Sound")
	Sound.SoundId = Id
	Sound:Play()
	Sound.Looped = true
	game.ReplicatedStorage.Event.SoundPlayer.AddNextbotMusic:FireAllClients(UserId, SoundBlock)
	if returnable or duration == -1 then
		return SoundBlock
	end

	task.wait(duration)
	SoundBlock:Destroy()
	return nil
end
function SoundCreator.new2DSoundEffect(Id, speed, returnable)
	local SoundInstance: Sound = Instance.new("Sound")
	SoundInstance.SoundId = Id
	SoundInstance.PlaybackSpeed = speed
	SoundInstance.Parent = SoundService
	SoundInstance:Play()
	if returnable then
		return SoundInstance
	end
	SoundInstance.Ended:Once(function(a0: string)
		SoundInstance:Destroy()
	end)
	return
end
function SoundCreator.UiSoundEffect(Name: string)
	local Sound: Sound = SoundService.PreloadedSounds:FindFirstChild(Name):Clone()
	Sound.Parent = SoundService
	Sound:Play()
	Sound.Ended:Once(function()
		Sound:Destroy()
	end)
end
SoundCreator.States = {

	["rbxassetid://8417230527"] = function(Position) --Heheha
		SoundCreator.new("rbxassetid://8417230527", Position, 0.75)
	end,
	["rbxassetid://99933358254659"] = function() --JP Calling
		SoundCreator.new2DSoundEffect("rbxassetid://99933358254659", 1)
	end,
}

return SoundCreator
