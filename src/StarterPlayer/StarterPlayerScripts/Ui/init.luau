local UserInputService = game:GetService("UserInputService")
local Ui = {}
local player = game.Players.LocalPlayer
local LobbyGui = player.PlayerGui:WaitForChild("LobbyGui")
local InventoryButton = LobbyGui.CanvasGroup.Inv
local ButtonEffectModule = require(script.ButtonEffectModule)
local InventoryUi = require(script.InventoryUi)

local ShopScript = require(script.ShopUi)
local ShopUi = player.PlayerGui:FindFirstChild("ShopUi")
local ShopButton = LobbyGui.CanvasGroup.ShopButton
local InventorySreenGUi = player.PlayerGui.inventory
function Ui.activate()
	ShopScript.activate()
	InventoryUi.activate()
end
InventoryButton.MouseButton1Up:Connect(function()
	InventoryUi.ChangeVisibility()
	if ShopUi.Enabled and InventorySreenGUi.Enabled then
		ShopScript.DisableUi()
	end
end)
ShopButton.MouseButton1Up:Connect(function()
	ShopScript.ChangeVisiblity()
	if InventorySreenGUi.Enabled and ShopUi.Enabled then
		InventoryUi.Disable()
	end
	print(InventorySreenGUi.Enabled, ShopUi.Enabled)
end)

ButtonEffectModule:LoadDescendantButtons(LobbyGui)

return Ui
