local cooldown = 0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local slidecooldown = 3
local movmentfunctions = require(ReplicatedStorage.Shared.MathForMovment)
local player = game.Players.LocalPlayer
local humanoid: Humanoid = player.Character:FindFirstChild("Humanoid")
local animatior = humanoid:WaitForChild("Animator")
local character = player.Character
local GuiService = game:GetService("GuiService")
local runanimation = animatior:LoadAnimation(character.Animation.RunAnimation)

local slideAnim = animatior:LoadAnimation(character.Animation.SlideAnimation)
local uip = game:GetService("UserInputService")
local running = false
local Contentprovidor = game:GetService("ContentProvider")
local Runservice = game:GetService("RunService")
local firstperson = false
local tweenproperties_sliding = {
	CameraOffset = Vector3.new(0, -2, 1),
}
local assets = {
	"rbxassetid://9525534210",
	"rbxassetid://1171402807",
}
local tweenproperties_running = {
	CameraOffset = Vector3.new(0, -1, -1.5),
}
local tweenproperties_normal = {
	CameraOffset = Vector3.new(0, -0.5, -1),
}
local head = player.Character:FindFirstChild("Head")
local Tweenservice = game:GetService("TweenService")
local tweeninfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false)
local tweeninfo_sliding = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false)
local tween_running = Tweenservice:Create(humanoid, tweeninfo, tweenproperties_running)
local tween_run_afterslide = Tweenservice:Create(humanoid, tweeninfo_sliding, tweenproperties_running)
local tween_normal_afterslide = Tweenservice:Create(humanoid, tweeninfo_sliding, tweenproperties_normal)
local tween_normal = Tweenservice:Create(humanoid, tweeninfo, tweenproperties_normal)
local tween_sliding = Tweenservice:Create(humanoid, tweeninfo_sliding, tweenproperties_sliding)
local raycastparams = RaycastParams.new()
raycastparams.FilterDescendantsInstances = { character }
raycastparams.FilterType = Enum.RaycastFilterType.Exclude
function startrun()
	running = true
	humanoid.WalkSpeed = 64
end
function cancelrun()
	running = false
	humanoid.WalkSpeed = 16
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
Contentprovidor:PreloadAsync(assets)
function isonmobile()
	if uip.TouchEnabled and not uip.KeyboardEnabled then
		return true
	end
end
local mobile = false
if isonmobile() then
	enableMobileUi()
end
function slide()
	local root = character:FindFirstChild("HumanoidRootPart")
	local oldcframe = root.CFrame.Rotation
	if os.clock() - cooldown < slidecooldown then
		return
	end
	cooldown = os.clock()
	if not movmentfunctions.isonfloor(character:FindFirstChild("HumanoidRootPart"), 4) then
		return
	end
	local allow = game.ReplicatedStorage.Playermovment.slidfunc:InvokeServer()
	if not allow then
		return
	end
	slideAnim:Play()
	if firstperson then
		tween_sliding:Play()
	end
	humanoid.WalkSpeed = 0
	local direction = root.CFrame.LookVector * -1
	local attachment = root.RootAttachment
	local alignorientation = Instance.new("AlignOrientation")
	alignorientation.MaxTorque = math.huge
	alignorientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	alignorientation.CFrame = CFrame.lookAt(root.Position, root.Position + root.CFrame.LookVector)
	alignorientation.RigidityEnabled = true
	alignorientation.Attachment0 = attachment
	alignorientation.Parent = root
	alignorientation.Responsiveness = 200
	local velocity = Instance.new("LinearVelocity")
	velocity.Attachment0 = attachment
	velocity.Parent = root
	velocity.MaxForce = math.huge
	local loopforshorttime
	loopforshorttime = Runservice.Heartbeat:Connect(function(deltatime)
		local raycastwall =
			game.Workspace:Raycast(root.Position - Vector3.new(0, -2.75, 0), root.CFrame.LookVector * 3, raycastparams)
		if raycastwall then
			print("WANDDDDDDDDDDD")
			root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			velocity:Destroy()
			slideAnim:Stop()
			alignorientation:Destroy()
			loopforshorttime:Disconnect()
		end
		local raycastforfloor = game.Workspace:Raycast(root.Position, Vector3.new(0, -5, 0), raycastparams)
		if raycastforfloor then
			local dotProduct = raycastforfloor.Normal:Dot(Vector3.new(0, 1, 0))
			local angle = math.deg(math.acos(dotProduct))
			direction = root.CFrame.LookVector:Cross(raycastforfloor.Normal):Cross(raycastforfloor.Normal)
		end
		velocity.VectorVelocity = direction.Unit * -160
	end)
	game.Debris:AddItem(velocity, 0.5)
	game.Debris:AddItem(alignorientation, 0.5)
	task.delay(0.48, function()
		if running then
			if firstperson then
				tween_run_afterslide:Play()
			end

			humanoid.WalkSpeed = 64
		else
			if firstperson then
				tween_normal_afterslide:Play()
			end

			humanoid.WalkSpeed = 32
		end
	end)
	task.delay(0.5, function()
		print("PLS_DESTROY")
		if not velocity then
			return
		end

		slideAnim:Stop()
		loopforshorttime:Disconnect()
	end)
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
GuiService.MenuOpened:Connect(function()
	runanimation:Stop()
end)
humanoid.Running:Connect(function(speed)
	if running then
		if speed > 16 then
			if not runanimation.IsPlaying then
				if firstperson then
					tween_running:Play()
				end

				runanimation:Play()
			end
		elseif speed == 0 then
			if runanimation.IsPlaying then
				runanimation:Stop()
				if firstperson then
					tween_normal:Play()
				end
			end
		end
	else
		if runanimation.IsPlaying then
			runanimation:Stop()
			if firstperson then
				tween_normal:Play()
			end
		end
	end
end)
humanoid.StateChanged:Connect(function(old, new)
	if new == Enum.HumanoidStateType.Landed then
		if running then
			if firstperson then
				tween_running:Play()
			end
			runanimation:Play()
		end
	elseif new == Enum.HumanoidStateType.Jumping or new == Enum.HumanoidStateType.Freefall then
		runanimation:Stop()
	end
end)
uip.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL3 then
		cancelrun()
	end
end)
head:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
	if head.LocalTransparencyModifier == 1 then
		if running then
			humanoid.CameraOffset = tweenproperties_running["CameraOffset"]
		else
			humanoid.CameraOffset = Vector3.new(0, -0.5, -1)
		end
		firstperson = true
	else
		firstperson = false
		humanoid.CameraOffset = Vector3.zero
	end
end)

script.Changed:Connect(function(property)
	if property == "Enabled" then
		print("nooooooooooooooooooooooooooooooooooooooooo")
	end
end)
