local Playeradded = {}
local movmentstatscript = require(script.Parent.Parent.Movmentstate.Movmentscript)
local gameProcessScript = require(script.Parent.Parent.gamestartingscripts.gameprocess)
local DataSave = require(script.Parent.Save)
local Data = require(script.Parent.PlayerData)
local UiUpdatedArray = {}

function Playeradded.activate()
	game.Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character)
			if UiUpdatedArray[player.UserId] == nil then
				print("cool")
				--local humanoid:Humanoid = player.PlayerGui.Rig.ViewportFrame.WorldModel.R6:FindFirstChild("Humanoid")
				--humanoid:ApplyDescriptionAsync(PlayerService:GetHumanoidDescriptionFromUserIdAsync(player.UserId))
				--UiUpdatedArray[player.UserId] = true
			end
			for _, object in character:GetDescendants() do
				if object:IsA("BasePart") then
					print("load")
					object.CollisionGroup = "player"
					print(object.Name, object.CollisionGroup)
				end
			end
			player.Character.DescendantAdded:Connect(function(object)
				if object:IsA("BasePart") then
					print("Cool")
					object.CollisionGroup = "player"
				end
			end)
			local humanoid: Humanoid = character:FindFirstChild("Humanoid")
			humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			humanoid.Died:Connect(function()
				print("playerdied")
				gameProcessScript.playerdied(player)
			end)
		end)

		DataSave.DeleteData(player)
		local Playerdata = DataSave.LoadData(player)
		player.Team = game.Teams.lobby
		movmentstatscript.addplayer(player)
		gameProcessScript.addplayer(player)
		Data.addplayer(player, Playerdata)
	end)

	game.Players.PlayerRemoving:Connect(function(player)
		gameProcessScript.removeplayer(player)
	end)

	print("Super ALles Klappt")
end
return Playeradded
