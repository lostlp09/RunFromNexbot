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
	print("yo did you start")
	local DepthOfField: DepthOfFieldEffect = Lighting:FindFirstChild("DepthOfField")
	local Atmosphere: Atmosphere = Lighting:FindFirstChild("Atmosphere")
	local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0)
	Status.FieldOfView.Apllied = true
	Status.FieldOfView.OldTime = os.clock()
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
	task.delay(duration, AbilitySurvconsequence.DisableFieldOfView)
end
function AbilitySurvconsequence.DisableFieldOfView()
	local delta = os.clock() - Status.FieldOfView.OldTime
	if delta >= time() then
		print("yo")
		Status["FieldOfView"].Apllied = false
	else
		task.delay(delta, AbilitySurvconsequence.DisableFieldOfView)
	end
end
function AbilitySurvconsequence.ApplyStatus(key, duration)
	if Status[key].Apllied then
		print("Soon")
	else
		StatusApplied[key](duration)
	end
	print(key)
end

return AbilitySurvconsequence
