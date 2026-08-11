local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InventoryUi = {}
local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local Inventory = PlayerGui:WaitForChild("inventory")
local ClientData = require(script.Parent.Parent.ClientData)
local NextBotUiInfo = require(script.Parent.NextbotUiInfo)
local ButtonConnection = {}
local ALlFrames = {}
local ViewportFrame = player.PlayerGui:WaitForChild("Rig").ViewportFrame
local Connections = {}
local RigAnimator = require(script.Parent.RigUI)
local NextbotModel = ViewportFrame.WorldModel.Nextbot
local EmoteInfo = require(script.Parent.EmoteInfo)
local RigUI = require(script.Parent.RigUI)
local EmoteButton = Inventory:WaitForChild("Categorybar").Emotes
local NextBotButton = Inventory.Categorybar.Emotes
local Structure = ViewportFrame.Structure
local InventoryPresets = ReplicatedStorage.Ui:WaitForChild("InventoryPresets")
local function ClearConnections(Array)
	for _, Connection: RBXScriptConnection in Array do
		if Connection then
			Connection:Disconnect()
		end
	end
end

function InventoryUi.activate()
	EmoteButton.MouseButton1Up:Connect(function()
		InventoryUi.LoadEmotes()
	end)
	NextBotButton.MouseButton1Up:Connect(function()
		InventoryUi.LoadCharacters()
	end)
end
local function DeleteEverying()
	for _, value in ButtonConnection do
		value:Disconnect()
	end
	for _, Object in ALlFrames do
		Object:Destroy()
	end
end
function InventoryUi.ChangeVisibility()
	if not Inventory.Enabled then
		Structure.PriceTag.Visible = false
		Inventory.Enabled = true
		InventoryUi.LoadCharacters()
	else
		InventoryUi.Disable()
	end
end
function InventoryUi.LoadCharacters()
	DeleteEverying()
	RigAnimator.RigInVisible()
	for key, obtained in pairs(ClientData.Data["NextbotOwned"]) do
		if obtained then
			local UiFrame = InventoryPresets.NextbotSelect:Clone()
			local Button: TextButton = UiFrame.Button
			local Icon = UiFrame.Icon
			Icon.Image = "rbxassetid://" .. tostring(NextBotUiInfo[key]["Icon"])
			UiFrame.Text.Text = key
			UiFrame.Name = key
			local Connection
			Connection = Button.MouseButton1Up:Connect(function()
				InventoryUi.UpdateMoreDetailed(key, NextBotUiInfo[key]["Icon"])
			end)
			table.insert(ALlFrames, UiFrame)
			table.insert(ButtonConnection, Connection)
			UiFrame.Parent = Inventory.Buttonloader
		end
	end
end
function InventoryUi.LoadEmotes()
	DeleteEverying()
	for key, obtained in pairs(ClientData.Data["EmoteOwned"]) do
		print(key)
		if obtained then
			local UiFrame = game.ReplicatedStorage.Ui.InventoryPresets.EmoteSelect:Clone()
			local Button: TextButton = UiFrame.Button
			local Icon = UiFrame.Icon
			print(key)
			Icon.Image = EmoteInfo[key]["Icon"]
			Icon.Text.Text = key
			UiFrame.Name = key
			local Connection
			Connection = Button.MouseButton1Up:Connect(function()
				print("cool")
				InventoryUi.EmoteMoreDetailed(key)
			end)
			table.insert(ALlFrames, UiFrame)
			table.insert(ButtonConnection, Connection)
			UiFrame.Parent = Inventory.ScrollingFrame
		end
	end
end
function InventoryUi.UpdateMoreDetailed(CharacterName, Image)
	ClearConnections(Connections)
	local Description: TextLabel = ViewportFrame.Structure:FindFirstChild("TextLabel")
	local Abilitybutton1 = ViewportFrame.Structure.Ability1
	local Abilitybutton2 = ViewportFrame.Structure.Ability2
	local EquipButton = ViewportFrame.Structure.Equip
	ViewportFrame.Visible = true
	print(ClientData.Data["NextbotEquiped"], CharacterName)
	if ClientData.Data["NextbotEquiped"] == CharacterName then
		EquipButton.Text = "Equiped"
	else
		local Connection
		Connection = EquipButton.Activated:Connect(function()
			ReplicatedStorage.Event.ChangeCharacter:FireServer(CharacterName)
			Connection:Disconnect()
			EquipButton.Text = "Equiped"
		end)
		EquipButton.Text = "Equip"
	end
	RigUI.RigInVisible()
	NextbotModel.Decal.Texture = "rbxassetid://" .. tostring(Image)
	Description.Text = NextBotUiInfo[CharacterName]["Description"]
	RigAnimator.AbilityButtonToggle(true)
	for i, Button in { Abilitybutton1, Abilitybutton2 } do
		Button.Image = NextBotUiInfo[CharacterName]["AbilityIcons"][i]
	end
end
function InventoryUi.EmoteMoreDetailed(EmoteName)
	RigAnimator.RigVisible()
	ViewportFrame.Visible = true
	RigAnimator.AbilityButtonToggle(false)
	ClearConnections(Connections)
	Structure.TextLabel.Text = EmoteInfo[EmoteName]["Description"]
	RigAnimator.playAnimation(EmoteInfo[EmoteName]["Emote"])
end
function InventoryUi.Disable()
	print("DisablePLs")
	Inventory.Enabled = false
	DeleteEverying()
	ClearConnections(Connections)
	RigAnimator.RigInVisible()
end
-------------------------------------------------- BUTTONS
return InventoryUi
