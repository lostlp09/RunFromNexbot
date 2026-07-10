local Ui = {}
local player = game.Players.LocalPlayer
local InventoryButton = player.PlayerGui:WaitForChild("MainButtons").Inv
local Clientdata = require(script.Parent:WaitForChild("ClientData"))
local Inventory = require(script.InventoryUi)
local ShopScript = require(script.ShopUi)
local ShopUi = player.PlayerGui:FindFirstChild("ShopUi")
local ShopButton = player.PlayerGui.MainButtons.ShopButton
local InventoryUi = player.PlayerGui.inventory
InventoryButton.MouseButton1Up:Connect(function()
	Inventory.ChangeVisibility()
	if ShopUi.Enabled and InventoryUi.Enabled then
		ShopScript.DisableUi()
	end
end)
ShopButton.MouseButton1Up:Connect(function()
	ShopScript.ChangeVisiblity()
	if InventoryUi.Enabled and ShopUi.Enabled then
		Inventory.Disable()
	end
	print(InventoryUi.Enabled, ShopUi.Enabled)
end)

return Ui
