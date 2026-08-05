local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local module = {}
local Character = script.Parent.Parent
local Humanoid: Humanoid = Character.Humanoid or Character:WaitForChild("Humanoid")
local Animator: Animator = Humanoid:FindFirstChild("Animator")
local Animations = ReplicatedStorage:FindFirstChild("Animations")
local SlideObject = Animations.Slide:FindFirstChild("SlideAnimation")
local SprintObject = Animations.Sprint:FindFirstChild("SprintAnimation")
local SprintAnimation = Animator:LoadAnimation(SprintObject)
local SlideAnimation = Animator:LoadAnimation(SlideObject)
local Root: Part = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart")
--local function StopAllAnimations()
--for _, anim in Animator:GetPlayingAnimationTracks() do
--	anim:Stop()
--end
--end
function module.Initialize()
	RunService:BindToSimulation(function()
		local HumanoidState = Humanoid:GetState()
		local IsSliding = Character:GetAttribute("Sliding")
		local IsSprinting = Character:GetAttribute("Sprinting")
		local IsOnAir = false

		local speed = Root.AssemblyLinearVelocity.Magnitude
		if HumanoidState == Enum.HumanoidStateType.Freefall or HumanoidState == Enum.HumanoidStateType.Jumping then
			IsOnAir = true
		end
		if IsSliding then
			if not SlideAnimation.IsPlaying then
				SlideAnimation:Play()
				if SprintAnimation.IsPlaying then
					SprintAnimation:Stop()
				end
			end
		else
			if SlideAnimation.IsPlaying then
				SlideAnimation:Stop()
			end
		end
		if IsSprinting and not IsOnAir and not IsSliding and speed > 1 then
			print(IsOnAir, speed)
			if not SprintAnimation.IsPlaying then
				SprintAnimation:Play()
			end
		elseif SprintAnimation.IsPlaying then
			print(speed)
			SprintAnimation:Stop()
			print(SprintAnimation.IsPlaying)
		end
	end)
end

return module
