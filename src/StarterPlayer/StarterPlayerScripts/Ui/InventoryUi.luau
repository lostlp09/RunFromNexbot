local InventoryUi = {}
local player = game.Players.LocalPlayer
local WhereAmi = "Inventory"
local Inventory = player.PlayerGui.inventory
local ClientData = require(script.Parent.Parent.ClientData)
local NextBotUiInfo = require(script.Parent.NextbotUiInfo)
local ButtonConnection = {}
local ALlFrames = {}
local ViewportFrame = player.PlayerGui.Rig.ViewportFrame
local Connections = {}
local RigAnimator = require(script.Parent.RigUI)
local NextbotModel = ViewportFrame.WorldModel.Nextbot
local EmoteInfo = require(script.Parent.EmoteInfo)
local EmoteButton = Inventory.Emote
local NextBotButton = Inventory.Character
local Structure = ViewportFrame.Structure

local function ClearConnections(Array)
	for i, Connection: RBXScriptConnection in Array do
		Connection:Disconnect()
	end
end

local function DeleteEverying()
	for i, value in ButtonConnection do
		value:Disconnect()
		ALlFrames[i]:Destroy()
	end
end
function InventoryUi.ChangeVisibility()
	if not Inventory.Enabled then
		Structure.PriceTag.Visible = false
		Inventory.Enabled = true
		InventoryUi.LoadCharacters()
	else
		Inventory.Enabled = false
		InventoryUi.Disable()
	end
end
function InventoryUi.LoadCharacters()
	DeleteEverying()
	RigAnimator.RigInVisible()
	for key, obtained in pairs(ClientData.Data["NextbotOwned"]) do
		if obtained then
			local UiFrame = game.ReplicatedStorage.Ui.InventoryPresets.Nexbotselect:Clone()
			local Button: TextButton = UiFrame.Button
			local Icon = UiFrame.Icon
			Icon.Image = NextBotUiInfo[key]["Icon"]
			Icon.Text.Text = key

			UiFrame.Name = key
			local Connection
			Connection = Button.MouseButton1Up:Connect(function()
				InventoryUi.UpdateMoreDetailed(key, NextBotUiInfo[key]["Icon"])
			end)

			table.insert(ALlFrames, UiFrame)
			table.insert(ButtonConnection, Connection)
			UiFrame.Parent = Inventory.ScrollingFrame
		end
	end
end
function AbilityInfo(Character, AbilityIndex) end

function InventoryUi.LoadEmotes()
	DeleteEverying()
	for key, obtained in pairs(ClientData.Data["EmoteOwned"]) do
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
	local Abilitybutton3 = ViewportFrame.Structure.Ability3
	local EquipButton = ViewportFrame.Structure.Equip
	ViewportFrame.Visible = true
	if ClientData.Data["NextBotEquiped"] == CharacterName then
		EquipButton.Text = "unequip"
	else
		EquipButton.Text = "equip"
	end
	print(Image)

	NextbotModel.Decal.ColorMapContent = Content.fromUri(Image)
	Description.Text = NextBotUiInfo[CharacterName]["Description"]
	RigAnimator.AbilityButtonToggle(true)
	for i, Button in { Abilitybutton1, Abilitybutton2, Abilitybutton3 } do
		Button.Image = NextBotUiInfo[CharacterName]["AbilityIcons"][i]
		Button.MouseEnter:Connect(function()
			AbilityInfo(CharacterName, i)
		end)
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
EmoteButton.MouseButton1Up:Connect(function()
	InventoryUi.LoadEmotes()
end)
NextBotButton.MouseButton1Up:Connect(function()
	InventoryUi.LoadCharacters()
end)

return InventoryUi
