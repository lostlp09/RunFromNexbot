local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Player = Players.LocalPlayer
local MakeJumpButtonVisible = require(Player.PlayerScripts.Rojo_Scripts.MakeJumpButtonVisible)
local SoundCreator = require(ReplicatedStorage.Shared.SoundCreator)
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
function localabiltys.ShapeShift(player: Player, secondAbility)
	print("Werde ich executed frage ? ", secondAbility)
	if secondAbility then
		MakeJumpButtonVisible.TurnMovmentButtons(false)
	else
		MakeJumpButtonVisible.TurnMovmentButtons(true)
	end
end

function localabiltys.Rocket(player: Player)
	--new Code so the rocket is not

	print("cool")
end

function localabiltys.Laugh()
	print("Cool")
end
function localabiltys.PorkCall()
	print("Cool")
end
function localabiltys.SpeedBoost()
	print("Ich werde einfach so ausgeführt lol omg lul")
	local Camera: Camera = Workspace.Camera
	local Sound = SoundCreator.new2DSoundEffect("rbxassetid://131853530932167", 1, true)
	local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0)
	local propertyTable = {
		FieldOfView = 100,
	}
	local tween = TweenService:Create(Camera, tweenInfo, propertyTable)
	tween:Play()
	task.wait(10)
	Sound:Stop()
	propertyTable = {
		FieldOfView = 70,
	}
	tween = TweenService:Create(Camera, tweenInfo, propertyTable)
	tween:Play()
end
function localabiltys.Thunder()
	print("Test")
end
return localabiltys
