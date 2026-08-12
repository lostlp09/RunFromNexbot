local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local module = {}

local player = Players.LocalPlayer
local Connection
local RunningTween: Tween
local SlideButton = player.PlayerGui.LobbyGui:WaitForChild("SlideButtonContainer").CooldownCanvas.SlideButton
local Progressbar = SlideButton.Parent.Progressbar
local InputBinding: InputBinding = player:WaitForChild("CustomInputs").ExtraMovement.Slide.Mobile
local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)
local TweenProperties = {
	Size = UDim2.fromScale(1, 0),
}
InputBinding.UIButton = SlideButton
local function CharacterAdded(Character)
	if RunningTween then
		RunningTween:Cancel()
	end
	if Connection then
		Connection:Disconnect()
		Connection = nil
	end
	Connection = Character:GetAttributeChangedSignal("Sliding"):Connect(function()
		if Character:GetAttribute("Sliding") then
			Progressbar.Size = UDim2.fromScale(1, 1)
			local Tween = TweenService:Create(Progressbar, tweenInfo, TweenProperties)
			RunningTween = Tween
			Tween:Play()
		end
	end)
end
if player.Character then
	CharacterAdded(player.Character)
end

player.CharacterAdded:Connect(CharacterAdded)

return module
