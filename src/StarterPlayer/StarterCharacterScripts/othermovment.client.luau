local cooldown = 0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local slidecooldown = 3
local movmentfunctions = require(ReplicatedStorage.Shared.MathForMovment)
local player = game.Players.LocalPlayer
local humanoid: Humanoid = player.Character:FindFirstChild("Humanoid")
local animatior: Animator = humanoid:WaitForChild("Animator")
local character = player.Character or player.CharacterAdded:wait()
local GuiService = game:GetService("GuiService")
local runanimation = animatior:LoadAnimation(character.Animation.RunAnimation)

local slideAnim = animatior:LoadAnimation(character.Animation.SlideAnimation)
local uip = game:GetService("UserInputService")
local running = false
local Contentprovidor = game:GetService("ContentProvider")
local firstperson = false
runanimation.Priority = Enum.AnimationPriority.Action
slideAnim.Priority = Enum.AnimationPriority.Action2
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
function isonmobile()
	if uip.TouchEnabled and not uip.KeyboardEnabled then
		return true
	else
		return false
	end
end
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
local connection
connection = uip.TouchPinch:Connect(function()
	if not mobile then
		enableMobileUi()
	end
	connection:Disconnect()
end)
uip.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.C or input.KeyCode == Enum.KeyCode.ButtonX then
		slide()
	elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL3 then
		startrun()
	end
end)
uip.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL3 then
		cancelrun()
	end
end)

humanoid.Running:Connect(function(speed)
	if running then
		if speed > 16 then
			if not runanimation.IsPlaying then
				print("Running")
			end
		elseif speed == 0 then
			if runanimation.IsPlaying then
				print("is not doing anything")
			end
		end
	else
		if runanimation.IsPlaying then
			print("is not doing anything")
		end
	end
end)
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
