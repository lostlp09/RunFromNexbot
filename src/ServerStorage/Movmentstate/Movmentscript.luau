local ReplicatedStorage = game:GetService("ReplicatedStorage")
local movment = {}
local playerstatus = {}

local movmentfunctions = require(ReplicatedStorage.Shared.MathForMovment)
local slidecooldown = 3
local nextbotplayer = require(script.Parent.Parent.Nextbots.Nextbotplayer)
function ChangeAnimations(player: Player)
	print("do you even run")
end
function movment.addplayer(player)
	task.spawn(ChangeAnimations, player)
	playerstatus[player.UserId] = table.clone({ sliding = false, sprinting = false, lastsliding = 0 })
	print(playerstatus)
end

ReplicatedStorage.Event.Movment.Sprint.OnServerEvent:Connect(function(player: Player)
	local Character = player.Character
	if not Character then
		return
	end
	local Humanoid: Humanoid = Character:FindFirstChild("Humanoid")
	local Animator = Humanoid:WaitForChild("Animator")
	local AnimationFolder = Character:FindFirstChild("Animation")

	if playerstatus[player.UserId].sprinting then
		playerstatus[player.UserId].sprinting = false
		Humanoid.WalkSpeed = 16
	else
		playerstatus[player.UserId].sprinting = true
		Humanoid.WalkSpeed = 64
		Animator:LoadAnimation(AnimationFolder.RunAnimation):Play()
	end
end)

ReplicatedStorage.Event.Movment.Slide.OnServerEvent:Connect(function(player: Player)
	local Character = player.Character
	local currentTime = os.clock()
	if currentTime - playerstatus[player.UserId].lastsliding < slidecooldown then
		return
	end
	if not Character then
		return
	end
	local root = Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character:FindFirstChild("Humanoid")
	local Animator: Animator = Humanoid:WaitForChild("Animator")
	local SlideAnimation = Animator:LoadAnimation(Character.Animation.SlideAnimation)
	local raycastparams = RaycastParams.new()
	raycastparams.FilterType = Enum.RaycastFilterType.Exclude
	raycastparams.FilterDescendantsInstances = { Character }
	local raycastforfloor = game.Workspace:Raycast(root.Position, Vector3.new(0, -5, 0), raycastparams)
	if not raycastforfloor then
		return
	end
	playerstatus[player.UserId].lastsliding = currentTime
	playerstatus[player.UserId].sliding = true
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

	direction = root.CFrame.LookVector:Cross(raycastforfloor.Normal):Cross(raycastforfloor.Normal)
	velocity.VectorVelocity = direction.Unit * -160
	game.Debris:AddItem(velocity, 0.5)
	game.Debris:AddItem(alignorientation, 0.5)
	task.delay(0.5, function()
		playerstatus[player.UserId].sliding = false
		SlideAnimation:Stop()
		if playerstatus[player.UserId].sprinting then
			Humanoid.WalkSpeed = 64
		else
			Humanoid.WalkSpeed = 32
		end
	end)
end)
function movment.activate() end

return movment
