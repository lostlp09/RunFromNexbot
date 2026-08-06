local SoundCreator = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local EmotePlayer = require(ReplicatedStorage.Shared.EmotePlayer.EmotePlayer)
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

	if returnable then
		return SoundBlock
	end
	task.wait(duration)
	SoundBlock:Destroy()
	return nil
end
function SoundCreator.new2DSoundEffect(Id, speed)
	local SoundInstance: Sound = Instance.new("Sound")
	SoundInstance.SoundId = Id
	SoundInstance.PlaybackSpeed = speed
	SoundInstance.Parent = SoundService
	SoundInstance:Play()
	SoundInstance.Ended:Wait()
	SoundInstance:Destroy()
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
