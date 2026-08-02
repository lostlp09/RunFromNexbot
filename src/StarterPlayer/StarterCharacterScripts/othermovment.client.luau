local cooldown = 0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local slidecooldown = 3
local player = game.Players.LocalPlayer
local humanoid: Humanoid = player.Character:FindFirstChild("Humanoid")
local character = player.Character or player.CharacterAdded:wait()

local running = false

local Movment = require(ReplicatedStorage.Shared.Movment)
Movment.RunFunction()

local raycastparams = RaycastParams.new()
raycastparams.FilterDescendantsInstances = { character }
raycastparams.FilterType = Enum.RaycastFilterType.Exclude
function startrun()
	running = true
	ReplicatedStorage.Event.Movment.Sprint:FireServer()
end
function cancelrun()
	running = false
	ReplicatedStorage.Event.Movment.Sprint:FireServer()
end
function enableMobileUi()
	local mobileUi = game.ReplicatedStorage.Ui.mobileui:Clone()
	mobileUi.Parent = player.PlayerGui
	mobileUi.run.MouseButton1Up:Connect(function()
		if running then
			running = false
			cancelrun()
			mobileUi.run:FindFirstChild("ImageLabel").Image = "rbxassetid:/9525534210"
		else
			running = true
			mobileUi.run:FindFirstChild("ImageLabel").Image = "rbxassetid://1171402807"
			startrun()
		end
	end)
end
function isonmobile() end
local mobile = false
if isonmobile() then
	enableMobileUi()
end
function slide()
	if os.clock() - cooldown < slidecooldown then
		return
	end
	game.ReplicatedStorage.Event.Movment.Slide:FireServer()
	cooldown = os.clock()
end

humanoid.StateChanged:Connect(function(oldState: Enum.HumanoidStateType, newstate: Enum.HumanoidStateType)
	local idleID = "rbxassetid://91015050376480"
	print("cool")
end)
--head:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
--if head.LocalTransparencyModifier == 1 then
--	if running then
--		humanoid.CameraOffset = tweenproperties_running["CameraOffset"]
--	else
--		humanoid.CameraOffset = Vector3.new(0, -0.5, -1)
--	end
--	firstperson = true
--else
--	firstperson = false
--	humanoid.CameraOffset = Vector3.zero
--	end
--end)
