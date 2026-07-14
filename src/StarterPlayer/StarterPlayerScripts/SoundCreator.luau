local SoundCreator = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
function SoundCreator.new(Id, position: Vector3, speed)
	local SoundBlock = ReplicatedStorage.Event:FindFirstChild("SoundPlayer").SoundBlock:Clone()
	SoundBlock.Parent = game.Workspace
	SoundBlock.Position = position
	local Sound: Sound = SoundBlock:FindFirstChild("Sound")
	Sound.SoundId = Id
	Sound:Play()
	Sound.Ended:Wait()
	SoundBlock:Destroy()
end
function SoundCreator.newFollwingSound(Id, UserId, duration, speed)
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
	task.wait(duration)
	SoundBlock:Destroy()
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
ReplicatedStorage.Event:FindFirstChild("SoundPlayer").PlaySound.OnClientEvent:Connect(function(Id, PositionOrUserId)
	task.spawn(SoundCreator.States[Id], PositionOrUserId)
end)

return SoundCreator
