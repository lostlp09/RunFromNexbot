local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local Jumpbutton: ImageButton = player.PlayerGui:WaitForChild("TouchGui").TouchControlFrame.JumpButton
local function isOnMobile()
	return UserInputService.TouchEnabled
end
if isOnMobile() then
	Jumpbutton.Visible = true
end
