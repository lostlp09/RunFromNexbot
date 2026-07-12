local SoundCreator = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
function SoundCreator.new(Id, position: CFrame)
	local SoundBlock = ReplicatedStorage.Event:FindFirstChild("SoundPlayer").SoundBlock:Clone()
	SoundBlock.Parent = game.Workspace
	SoundBlock.Position = position
	local Sound: Sound = SoundBlock:FindFirstChild("Sound")
	Sound.SoundId = Id
	Sound:Play()
	Sound.Ended:Wait()
	SoundBlock:Destroy()
end
ReplicatedStorage.Event:FindFirstChild("SoundPlayer").PlaySound.OnClientEvent:Connect(function(Id, position)
	SoundCreator.new(Id, position)
end)
return SoundCreator
