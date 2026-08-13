local MovmentShared = {}
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Teams = game:GetService("Teams")
local SprintAnimation: Animation = ReplicatedStorage.Animations.Sprint.SprintAnimation
local SlideAnimation: Animation = ReplicatedStorage.Animations.Slide.SlideAnimation
if RunService:IsClient() then
	ContentProvider:PreloadAsync({ SlideAnimation.AnimationId, SprintAnimation.AnimationId })
end
local raycastparams = RaycastParams.new()
raycastparams.FilterType = Enum.RaycastFilterType.Exclude
local PlayerSlidedCooldown = {}
function MovmentShared.RunFunction()
	RunService:BindToSimulation(function(delta)
		for _, player in Players:GetPlayers() do
			if RunService:IsClient() and Players.LocalPlayer ~= player then
				continue
			end

			local Character = player.Character
			if not Character then
				continue
			end

			local Root: Part = Character:FindFirstChild("HumanoidRootPart")
			if not Root then
				continue
			end
			if Character:GetAttribute("SlidingCooldown") == nil then
				Character:SetAttribute("SlidingCooldown", 10)
			else
				Character:SetAttribute("SlidingCooldown", Character:GetAttribute("SlidingCooldown") + delta)
			end
			local InputsFolder = player:FindFirstChild("CustomInputs")
			local Humanoid: Humanoid = Character:FindFirstChild("Humanoid")
			raycastparams.FilterDescendantsInstances = { Character }
			local raycastforfloor = game.Workspace:Raycast(Root.Position, Vector3.new(0, -5, 0), raycastparams)

			if raycastforfloor then
				if raycastforfloor.Instance:GetAttribute("Pad") then
					Root.AssemblyLinearVelocity =
						Vector3.new(Root.AssemblyLinearVelocity.X, 200, Root.AssemblyLinearVelocity.Z)
				end
			end
			if not InputsFolder then
				continue
			end
			local InputContainter = InputsFolder:FindFirstChild("ExtraMovement")
			for _, Input: InputAction in InputContainter:GetChildren() do
				local isPressed = false
				isPressed = Input:GetState()
				if Input.Name == "Slide" then
					if isPressed then
						if
							Character:GetAttribute("Sliding")
							or Character:GetAttribute("SlidingPressed")
							or Humanoid:GetState() == Enum.HumanoidStateType.Freefall
							or Humanoid:GetState() == Enum.HumanoidStateType.Jumping
							or (player.Team ~= Teams.Survivor and not Character:GetAttribute("Shapeshifting"))
							or Character:GetAttribute("SlidingCooldown") < 5
						then
							continue
						end
						local direction = Root.CFrame.LookVector
						if not raycastforfloor then
							continue
						end

						direction = Root.CFrame.LookVector:Cross(raycastforfloor.Normal):Cross(raycastforfloor.Normal)
						local AlignOrientation = Root:FindFirstChild("AlignOrientationSlide")
						local Velocity = Root:FindFirstChild("SlideVelocity")
						if not Velocity then
							continue
						end
						Character:SetAttribute("SlidingCooldown", 0)
						AlignOrientation.CFrame = CFrame.lookAt(Root.Position, Root.Position + Root.CFrame.LookVector)
						AlignOrientation.Enabled = true
						Velocity.Enabled = true
						local oldHight = Humanoid.JumpHeight
						Humanoid.JumpHeight = 0

						Velocity.VectorVelocity = direction.Unit * -160
						Character:SetAttribute("Sliding", true)

						AlignOrientation.Enabled = true
						task.delay(0.5, function()
							Velocity.Enabled = false
							AlignOrientation.Enabled = false
							Character:SetAttribute("Sliding", false)
							Humanoid.JumpHeight = oldHight
						end)
					else
						Character:SetAttribute("SlidingPressed", false)
					end
				elseif Input.Name == "Sprint" then
					local IsSliding = Character:GetAttribute("Sliding")
					local IsSprinting = Character:GetAttribute("Sprinting")
					if player.Team ~= Teams.Survivor then
						continue
					end
					if isPressed then
						if not IsSprinting and not IsSliding then
							Character:SetAttribute("Sprinting", true)
							Humanoid.WalkSpeed = 64
						end
					elseif IsSprinting then
						Humanoid.WalkSpeed = 16
						Character:SetAttribute("Sprinting", false)
					end
				end
			end
		end
	end)
end

return MovmentShared
