local localabiltys = {}
function localabiltys.Beam(player: Player)
	local Character = player.Character
	local root = Character:FindFirstChild("HumanoidRootPart")
	local AliginPosition = Instance.new("AlignPosition")
	AliginPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
	AliginPosition.MaxForce = math.huge
	AliginPosition.Responsiveness = 100
	AliginPosition.Position = root.Position
	AliginPosition.Parent = root
	AliginPosition.Enabled = true
	AliginPosition.Attachment0 = root.RootAttachment
	task.spawn(function()
		task.wait(0.5)
		AliginPosition:Destroy()
	end)
end
function localabiltys.ShapeShift(player: Player)
	local character = player.Character
	local humanoid: Humanoid = character:FindFirstChild("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	local AliginPosition = Instance.new("AlignPosition")
	AliginPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
	AliginPosition.MaxForce = math.huge
	AliginPosition.Responsiveness = 100
	AliginPosition.Position = root.Position
	AliginPosition.Parent = root
	AliginPosition.Enabled = true
	AliginPosition.Attachment0 = root.RootAttachment
	game.Debris:AddItem(AliginPosition, 0.5)
	humanoid.CameraOffset = Vector3.new(0, 0, 0)
end

function localabiltys.Rocket(player: Player)
	--new Code so the rocket is not

	local Character = player.Character
	local root = Character:FindFirstChild("HumanoidRootPart")
	local AliginPosition = Instance.new("AlignPosition")
	AliginPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
	AliginPosition.MaxForce = math.huge
	AliginPosition.Responsiveness = 100
	AliginPosition.Position = root.Position
	AliginPosition.Parent = root
	AliginPosition.Enabled = true
	AliginPosition.Attachment0 = root.RootAttachment

	task.spawn(function()
		task.wait(0.5)
		AliginPosition:Destroy()
	end)
end

function localabiltys.FieldOfView()
	print("Cool")
end
function localabiltys.PorkCall()
	print("Cool")
end
function localabiltys.SpeedBoost()
	print("Cool")
end
return localabiltys
