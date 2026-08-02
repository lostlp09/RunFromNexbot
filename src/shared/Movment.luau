local MovmentShared = {}
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SprintAnimation: Animation = ReplicatedStorage.Animations.Sprint.SprintAnimation
local SlideAnimation: Animation = ReplicatedStorage.Animations.Slide.SlideAnimation
if RunService:IsClient() then
	ContentProvider:PreloadAsync({ SlideAnimation.AnimationId, SprintAnimation.AnimationId })
end

function MovmentShared.RunFunction()
	print("Do i even get Created")
	RunService:BindToSimulation(function()
		print("hello ?")
		for _, player in Players:GetPlayers() do
			local Character = player.Character
			if not Character then
				continue
			end
			local Root = Character:FindFirstChild("HumanoidRootPart")
			local InputsFolder = player:FindFirstChild("CustomInputs")
			local Humanoid: Humanoid = Character:FindFirstChild("Humanoid")
			local Animator = Humanoid:FindFirstChild("Animator")

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
						then
							continue
						end
						local ExestingSlideAnimation = Animator:GetTrackByAnimationId(SlideAnimation.AnimationId)
						if ExestingSlideAnimation and RunService:IsServer() then
							ExestingSlideAnimation:Play(0.3)
						else
							if RunService:IsClient() then
								local slideAnimation = Animator:LoadAnimation(SlideAnimation)
								slideAnimation:Play(0.3)
							end
						end
						local raycastparams = RaycastParams.new()
						raycastparams.FilterType = Enum.RaycastFilterType.Exclude
						raycastparams.FilterDescendantsInstances = { Character }
						local raycastforfloor =
							game.Workspace:Raycast(Root.Position, Vector3.new(0, -5, 0), raycastparams)
						if not raycastforfloor then
							continue
						end

						local direction =
							Root.CFrame.LookVector:Cross(raycastforfloor.Normal):Cross(raycastforfloor.Normal)
						local AlignOrientation: AlignOrientation = Root:FindFirstChild("AlignOrientationSlide")
						local Velocity: LinearVelocity = Root:FindFirstChild("SlideVelocity")
						if not Velocity then
							continue
						end

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
							if ExestingSlideAnimation then
								ExestingSlideAnimation:Stop(0.3)
							else
								Animator:GetTrackByAnimationId(SlideAnimation.AnimationId):Stop(0.3)
							end
							if Character:GetAttribute("Sprinting") then
								local Sprint = Animator:GetTrackByAnimationId(SprintAnimation.AnimationId)
									or Animator:LoadAnimation(SprintAnimation)
								Sprint:Play()
							end
						end)
					else
						Character:SetAttribute("SlidingPressed", false)
					end
				elseif Input.Name == "Sprint" then
					local IsSliding = Character:GetAttribute("Sliding")
					local IsSprinting = Character:GetAttribute("Sprinting")
					local ExestingSlideAnimation = Animator:GetTrackByAnimationId(SprintAnimation.AnimationId)
					if isPressed then
						if not IsSprinting and not IsSliding then
							if ExestingSlideAnimation and RunService:IsServer() then
								ExestingSlideAnimation:Play(0.3)
							else
								if RunService:IsClient() then
									local SprintAni = Animator:LoadAnimation(SprintAnimation)
									SprintAni:Play(0.3)
								end
							end
							Character:SetAttribute("Sprinting", true)
							Humanoid.WalkSpeed = 64
						end
					elseif IsSprinting then
						Humanoid.WalkSpeed = 16
						Character:SetAttribute("Sprinting", false)
						local SprintAni = Animator:GetTrackByAnimationId(SprintAnimation.AnimationId)
						if SprintAni then
							SprintAni:Stop()
						end
					end
				end
			end
		end
	end)
end

return MovmentShared
