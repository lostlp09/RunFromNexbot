local RigUi = {}
local player = game.Players.LocalPlayer

local RiGscreen = player.PlayerGui.Rig
local Rig = RiGscreen.ViewportFrame.WorldModel.R6
local NexbotModel = RiGscreen.ViewportFrame.WorldModel.Nextbot
local characterhumanoid = RiGscreen.ViewportFrame.WorldModel.R6.Humanoid
local Animator: Animator = characterhumanoid:FindFirstChild("Animator")
local AnimationObject: Animation = characterhumanoid.Parent.Emote
local Structure = RiGscreen.ViewportFrame.Structure
local animation

function RigUi.ReturnAnimator()
	return Animator
end
function RigUi.playAnimation(id)
	if animation then
		animation:Stop()
	end
	AnimationObject.AnimationId = id
	animation = Animator:LoadAnimation(AnimationObject)
	animation:Play()
	animation.Looped = true
	print(Animator:GetPlayingAnimationTracks())
end

function RigUi.RigVisible()
	NexbotModel.Decal.Transparency = 1
	for _, part in Rig:GetDescendants() do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			part.Transparency = 0
		end
	end
end
function RigUi.RigInVisible()
	print(NexbotModel)
	NexbotModel.Decal.Transparency = 0
	for _, part in Rig:GetDescendants() do
		if part:IsA("BasePart") then
			part.Transparency = 1
		end
	end
end
function RigUi.DisableViewPort()
	RiGscreen.ViewportFrame.Visible = false
end
function RigUi.EnableViewPort()
	RiGscreen.ViewportFrame.Visible = true
end

function RigUi.NextbotTexture(Texture)
	print(Texture)
	NexbotModel.Decal.Texture = "rbxassetid://" .. tostring(Texture)
end

function RigUi.AbilityButtonToggle(boolean)
	Structure.Ability1.Visible = boolean
	Structure.Ability2.Visible = boolean
end
return RigUi
