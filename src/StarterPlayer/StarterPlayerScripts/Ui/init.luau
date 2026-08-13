local UserInputService = game:GetService("UserInputService")
local Ui = {}
local player = game.Players.LocalPlayer
local LobbyGui = player.PlayerGui:WaitForChild("LobbyGui")
local InventoryButton = LobbyGui.Frame.Inv
local ButtonEffectModule = require(script.ButtonEffectModule)
local InventoryUi = require(script.InventoryUi)
local ClientData = require(script.Parent.ClientData)
local ShopScript = require(script.ShopUi)
local Winlose = require(script.Winlose)
local ShopUi = player.PlayerGui:FindFirstChild("ShopUi")
local ShopButton = LobbyGui.Frame.ShopButton
local InventorySreenGUi = player.PlayerGui.inventory

function Ui.activate()
	ShopScript.activate()
	InventoryUi.activate()
	Winlose.activate()
end
InventoryButton.Activated:Connect(function()
	print(ClientData)
	if ClientData.Data["EmoteOwned"] == nil or ClientData.Data["NextbotOwned"] == nil then
		return
	end
	print("Test")
	InventoryUi.ChangeVisibility()
	if InventorySreenGUi.Enabled then
		local Mobileui = player.PlayerGui:FindFirstChild("MobileUi")
		if Mobileui then
			print("DisablethatShit")
			Mobileui.Enabled = false
		end
	else
		local Mobileui = player.PlayerGui:FindFirstChild("MobileUi")
		if Mobileui then
			Mobileui.Enabled = true
		end
	end
	if ShopUi.Enabled and InventorySreenGUi.Enabled then
		ShopScript.DisableUi()
	end
end)
ShopButton.Activated:Connect(function()
	if ClientData.Data["EmoteOwned"] == nil or ClientData.Data["NextbotOwned"] == nil then
		return
	end
	ShopScript.ChangeVisiblity()
	if ShopUi.Enabled then
		local Mobileui = player.PlayerGui:FindFirstChild("MobileUi")
		if Mobileui then
			Mobileui.Enabled = false
		end
	else
		local Mobileui = player.PlayerGui:FindFirstChild("MobileUi")
		if Mobileui then
			Mobileui.Enabled = true
		end
	end
	if InventorySreenGUi.Enabled and ShopUi.Enabled then
		InventoryUi.Disable()
	end
	print(InventorySreenGUi.Enabled, ShopUi.Enabled)
end)

ButtonEffectModule:LoadDescendantButtons(LobbyGui.Frame)

return Ui
