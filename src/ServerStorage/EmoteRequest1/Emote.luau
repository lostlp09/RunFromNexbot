local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local AudioPlayer = require(script.Parent.AudioPlayer)
local EmotePlayer = require(ReplicatedStorage.Shared.EmotePlayer.EmotePlayer)
local PlayerData = require(ServerStorage.Rojo_Scripts.Playeradded.PlayerData)
local EmoteRequest: RemoteEvent = ReplicatedStorage.Event.RequestEmote
local module = {}

EmoteRequest.OnServerEvent:Connect(function(Player: Player, Emote: string)
	local Character = Player.Character
	local Humanoid = Character:FindFirstChild("Humanoid")
	local Animator = Humanoid:FindFirstChild("Animator")
	local HumanoidRootPart: Part = Character:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart.AssemblyLinearVelocity.Magnitude > 0.2 then
		print("Player is not  standing Still ")
		print(HumanoidRootPart.AssemblyLinearVelocity)
		return
	end

	if not Character or not Humanoid then
		print("player doenst have character or Humanoid")
		return
	end
	if PlayerData[Player.UserId].EmoteOwned[Emote] then
		if Character:GetAttribute("Emoting") then
			print("Broooo")
			local EmoteBlock = HumanoidRootPart:FindFirstChild("EmoteBlock")
			if EmoteBlock then
				EmoteBlock:Destroy()
			end
		end
		print("cool")
		EmotePlayer.Play(Emote, Animator)
		print("Did you Run")
		Character:SetAttribute("Emoting", true)
		print(Character:GetAttribute("Emoting"))
		print(Player.UserId)
		AudioPlayer.PlayAudio(Emote, Player)
	else
		Player:Kick("Cheater or Bug")
	end
end)

return module
