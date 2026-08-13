local module = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local MobileGui = ReplicatedStorage.Ui:WaitForChild("MobileUi")
local SprintButton: ImageButton
local SlideButton: ImageButton
function module.isOnMobile()
	return UserInputService.TouchEnabled
end
local function EnableMobileGui()
	local Jumpbutton: ImageButton = player.PlayerGui:WaitForChild("TouchGui").TouchControlFrame.JumpButton
	Jumpbutton.Visible = true
	MobileGui = MobileGui:Clone()
	MobileGui.Parent = player.PlayerGui
	SprintButton = MobileGui:FindFirstChild("run")
	local SprintBinding: InputBinding = player:WaitForChild("CustomInputs"):WaitForChild("ExtraMovement").Sprint.Mobile
	print(SprintBinding)
	if SprintBinding then
		print(SprintButton)
		SprintBinding.UIButton = SprintButton
	end

	print(SprintBinding.UIButton)
end
function module.isOnController()
	return UserInputService.GamepadEnabled
end
function module.activate()
	if module.isOnMobile() then
		task.spawn(function()
			EnableMobileGui()
		end)
	end
	SlideButton = player.PlayerGui:WaitForChild("LobbyGui"):WaitForChild("GameUi").SlideButtonContainer
end

function module.TurnMovmentButtons(bool)
	if SprintButton then
		SprintButton.Visible = bool
	end
	if SlideButton then
		SlideButton.Visible = bool
	end
end
return module
