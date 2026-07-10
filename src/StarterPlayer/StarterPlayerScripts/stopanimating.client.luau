local player = game.Players.LocalPlayer
function stopallanimations(Animator)
	for i, Animation in Animator:GetPlayingAnimationTracks() do
		print("do you got any animation ?")
		print(Animation)
		Animation:Stop()
	end
end
game.ReplicatedStorage.playeranimation.disableanimation.OnClientEvent:Connect(function()
	local character = player.Character or player:WaitForChild("Character")
	local Humannoid = character:FindFirstChild("humanoid") or character:WaitForChild("Humanoid")
	local Animator = Humannoid:FindFirstChild("Animator")
	if Animator then
		stopallanimations(Animator)
	end
end)
