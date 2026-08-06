local module = {}
local RunService = game:GetService("RunService")

local Emotes = {
	["Shuffle"] = 109359932912715,
	["Crazy"] = 99250503928355,
	["Chill"] = 110335743551355,
}

module.EmoteAudio = {
	["Shuffle"] = 123048251088564,
	["Crazy"] = 79261923361270,
	["Chill"] = 1835394220,
}

function module.Play(key, Animator: Animator)
	print("I got Runned")
	local AnimationID = Emotes[key]
	local AnimationInstance = Instance.new("Animation")
	local id = "rbxassetid://" .. tostring(AnimationID)

	AnimationInstance.AnimationId = id
	for _, Track in Animator:GetPlayingAnimationTracks() do
		Track:Stop()
	end
	local Animation = Animator:GetTrackByAnimationId(id) or Animator:LoadAnimation(AnimationInstance)
	Animation.Looped = true
	Animation:Play()
end

return module
