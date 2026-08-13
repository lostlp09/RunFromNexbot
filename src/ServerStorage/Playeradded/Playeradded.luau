local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Playeradded = {}
local gameProcessScript = require(script.Parent.Parent.gamestartingscripts.gameprocess)
local DataSave = require(script.Parent.Save)
local Data = require(script.Parent.PlayerData)
local Save = require(script.Parent.Save)
local InputFolder = ReplicatedStorage:WaitForChild("CustomInputs")
local UiUpdatedArray = {}

function Playeradded.activate()
	game.Players.PlayerAdded:Connect(function(player)
		local InputClone = InputFolder:Clone()
		InputClone.Parent = player
		player.CharacterAdded:Connect(function(character: Part)
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
			local humanoid = character:FindFirstChild("Humanoid")
			humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			humanoid.Died:Connect(function()
				print("playerdied")
				gameProcessScript.playerdied(player, false)
			end)
			local alignorientation = Instance.new("AlignOrientation")
			local root = character:FindFirstChild("HumanoidRootPart")
			alignorientation.MaxTorque = math.huge
			local attachment = root.RootAttachment
			alignorientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
			alignorientation.RigidityEnabled = true
			alignorientation.Enabled = false
			alignorientation.Attachment0 = attachment
			alignorientation.Responsiveness = 200
			alignorientation.Name = "AlignOrientationSlide"
			alignorientation.Parent = root
			local velocity: LinearVelocity = Instance.new("LinearVelocity")
			velocity.Attachment0 = attachment
			velocity.Name = "SlideVelocity"
			velocity.MaxForce = math.huge
			velocity.Enabled = false
			velocity.Parent = root
		end)

		local Playerdata = DataSave.LoadData(player)
		player.Team = game.Teams.lobby
		task.spawn(function()
			gameProcessScript.addplayer(player)
		end)
		Data.addplayer(player, Playerdata)
	end)

	game.Players.PlayerRemoving:Connect(function(player)
		task.spawn(function()
			gameProcessScript.removeplayer(player)
		end)
	end)

	print("Super ALles Klappt")
end
return Playeradded
