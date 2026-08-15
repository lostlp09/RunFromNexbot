local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundCreator = require(ReplicatedStorage.Shared.SoundCreator)
local module = {}
local Character = script.Parent.Parent
local Humanoid: Humanoid = Character.Humanoid or Character:WaitForChild("Humanoid")
local Animator = Humanoid:FindFirstChild("Animator")
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
		local IsEmoting = Character:GetAttribute("Emoting")
		local IsOnAir = false

		local speed = Root.AssemblyLinearVelocity.Magnitude
		if speed > 1 and IsEmoting then
			Character:SetAttribute("Emoting", false)
			for _, Track in Animator:GetPlayingAnimationTracks() do
				Track:Stop()
			end
		end
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
		if IsSprinting and not IsOnAir and not IsSliding and speed > 3 then
			if not SprintAnimation.IsPlaying then
				SprintAnimation:Play()
			end
		elseif SprintAnimation.IsPlaying then
			SprintAnimation:Stop()
		end
	end)
end
if RunService:IsClient() then
	Character:GetAttributeChangedSignal("Sliding"):Connect(function()
		if Character:GetAttribute("Sliding") then
			SoundCreator.UiSoundEffect("Slide")
		end
	end)
end
if RunService:IsServer() then
	Character:GetAttributeChangedSignal("Emoting"):Connect(function()
		local NotEmoting = not Character:GetAttribute("Emoting")
		if NotEmoting then
			local EmoteBlock = Character.HumanoidRootPart:FindFirstChild("EmoteBlock")
			EmoteBlock:Destroy()
		end
	end)
end

return module
