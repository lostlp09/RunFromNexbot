local module = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local MobileGui = ReplicatedStorage.Ui:WaitForChild("MobileUi")
local SprintButton: ImageButton
function module.isOnMobile()
	return UserInputService.TouchEnabled
end
if module.isOnMobile() then
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
function module.TurnSprintButton(bool)
	SprintButton.Visible = bool
end
return module
