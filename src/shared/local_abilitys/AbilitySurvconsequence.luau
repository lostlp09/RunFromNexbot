local AbilitySurvconsequence = {}

local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local Status = {
	Blinded = { Apllied = false, duration = 0, OldTime = 0 },
	FieldOfView = { Apllied = false, duration = 0, OldTime = 0 },
}
local StatusApplied = {
	FieldOfView = function(duration)
		AbilitySurvconsequence.FieldOfView(duration)
	end,
}
function AbilitySurvconsequence.FieldOfView(duration)
	if Status.FieldOfView.Apllied then
		print("its running back to back")
		Status.FieldOfView.duration = Status.FieldOfView.duration + duration
	else
		print("yo did you start")
		local DepthOfField: DepthOfFieldEffect = Lighting:FindFirstChild("DepthOfField")
		local Atmosphere: Atmosphere = Lighting:FindFirstChild("Atmosphere")
		local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0)
		Status.FieldOfView.Apllied = true
		Status.FieldOfView.OldTime = os.clock()
		Status.FieldOfView.duration = duration
		DepthOfField.Enabled = true
		local propertyTable = {
			FarIntensity = 1,
			NearIntensity = 1,
			InFocusRadius = 12.405,
		}
		print(duration)
		local tween: Tween = TweenService:Create(DepthOfField, tweenInfo, propertyTable)
		local properties2 = {
			Haze = 10,
			Density = 1,
			Color = Color3.fromRGB(0, 0, 0),
			Decay = Color3.fromRGB(0, 0, 0),
		}
		local tween2 = TweenService:Create(Atmosphere, tweenInfo, properties2)
		tween2:Play()
		tween:Play()
	end

	task.delay(duration, AbilitySurvconsequence.DisableFieldOfView)
end
function AbilitySurvconsequence.DisableFieldOfView()
	local delta = os.clock() - Status.FieldOfView.OldTime

	if delta >= Status.FieldOfView.duration then
		local DepthOfField: DepthOfFieldEffect = Lighting:FindFirstChild("DepthOfField")
		local Atmosphere: Atmosphere = Lighting:FindFirstChild("Atmosphere")
		local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0)
		print("yo")
		Status["FieldOfView"].Apllied = false
		local propertyTable = {
			FarIntensity = 0.1,
			NearIntensity = 0.75,
			InFocusRadius = 30,
		}
		local tween: Tween = TweenService:Create(DepthOfField, tweenInfo, propertyTable)
		local properties2 = {
			Haze = 0,
			Density = 0.3,
			Color = Color3.fromRGB(199, 199, 199),
			Decay = Color3.fromRGB(106, 112, 125),
		}
		local tween2 = TweenService:Create(Atmosphere, tweenInfo, properties2)
		tween2:Play()
		tween:Play()
	else
		task.delay(Status.FieldOfView.duration - delta, AbilitySurvconsequence.DisableFieldOfView)
	end
end
function AbilitySurvconsequence.ApplyStatus(key, duration)
	StatusApplied[key](duration)
end

return AbilitySurvconsequence
