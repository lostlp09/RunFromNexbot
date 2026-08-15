local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Teams = game:GetService("Teams")
local VersionControlService = game:GetService("VersionControlService")
local player = Players.LocalPlayer
local module = {}
local BackGroundsSounds = SoundService:FindFirstChild("BackGroundMusic")
local ChaseMusic: Sound = SoundService:FindFirstChild("ChaseMusic")

function easeOutQuart(x)
	return 1 - (1 - x) ^ 4
end
local Nextbots = {}
function module.instantiate()
	print("DID I GOT INSTANTIATE")
	for _, Player in Players:GetPlayers() do
		if Player.Team == Teams.Nextbots then
			table.insert(Nextbots, Player)
		end
	end
	local Connection
	local firstTime = 0
	Connection = RunService.RenderStepped:Connect(function()
		if player.Team ~= Teams.Survivor then
			ChaseMusic.Volume = 0
			BackGroundsSounds.Volume = 0.7
			Connection:Disconnect()
			return
		end
		local ShortestDistance = 101
		for _, Nextbot in Nextbots do
			if Nextbot.Character then
				local NextbotRoot = Nextbot.Character:FindFirstChild("HumanoidRootPart")
				if not NextbotRoot then
					continue
				end
				if player.Character then
					local Root = player.Character:FindFirstChild("HumanoidRootPart")
					local offset = (NextbotRoot.Position - Root.Position)
					if Root then
						local Distance = offset.Magnitude
						print(Distance)
						if Distance < ShortestDistance then
							ShortestDistance = Distance
						end
					end
				end
			end
		end
		if ShortestDistance <= 100 then
			if firstTime then
				ChaseMusic.TimePosition = 2
				firstTime = false
			end
			local Volume = 0.7 * ShortestDistance / 100
			BackGroundsSounds.Volume = Volume
			ChaseMusic.Volume = 0.7 - Volume
		else
			firstTime = true
			ChaseMusic.Volume = 0
			BackGroundsSounds.Volume = 0.7
		end
	end)
end

return module
