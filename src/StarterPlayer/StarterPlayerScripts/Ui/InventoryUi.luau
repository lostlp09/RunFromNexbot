local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local InventoryUi = {}
local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local Inventory = PlayerGui:WaitForChild("inventory")
local EmoteScript = require(Players.LocalPlayer.PlayerScripts.Rojo_Scripts.EmoteScript)
local EmotePlayer = require(ReplicatedStorage.Shared.EmotePlayer.EmotePlayer)
local ClientData = require(script.Parent.Parent.ClientData)
print("EmoteScript ClientData:", ClientData, tostring(ClientData):match("0x%x+"))
local NextBotUiInfo = require(script.Parent.NextbotUiInfo)
local ButtonConnection = {}
local ALlFrames = {}
local ViewportFrame = player.PlayerGui:WaitForChild("Rig").ViewportFrame
local Connections = {}
local RigAnimator = require(script.Parent.RigUI)
local NextbotModel = ViewportFrame.WorldModel.Nextbot
local EmoteInfo = require(script.Parent.EmoteInfo)
local RigUI = require(script.Parent.RigUI)
local ShopUi = require(script.Parent.ShopUi)
local EmoteButton = Inventory:WaitForChild("Categorybar").Emotes
local NextBotButton = Inventory.Categorybar.Character
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
	print("wie oft")
	EmoteButton.Activated:Connect(function()
		InventoryUi.LoadEmotes()
	end)
	NextBotButton.Activated:Connect(function()
		print("Führesaus")
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
	ViewportFrame.Visible = false
	print("Werde ich ausgeführt")
	DeleteEverying()
	RigAnimator.RigInVisible()
	for key, obtained in pairs(ClientData.Data["NextbotOwned"]) do
		print("Wird die schleife ausgeführt")
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
	ViewportFrame.Visible = false
	for key, obtained in pairs(ClientData.Data["EmoteOwned"]) do
		if obtained then
			local UiFrame = game.ReplicatedStorage.Ui.InventoryPresets.EmoteSelect:Clone()
			UiFrame.Parent = Inventory.Buttonloader
			local Button: TextButton = UiFrame.Button
			UiFrame.Text.Text = key
			local Connection
			local Animator = UiFrame.ViewportFrame.WorldModel.R6.Humanoid.Animator
			print(key)
			EmotePlayer.Play(key, Animator)
			Connection = Button.Activated:Connect(function()
				print("cool")
				InventoryUi.EmoteMoreDetailed(key)
			end)
			table.insert(ALlFrames, UiFrame)
			table.insert(ButtonConnection, Connection)
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
	local Connection
	print(ClientData.Data["NextbotEquiped"], CharacterName)
	if ClientData.Data["NextbotEquiped"] == CharacterName then
		EquipButton.Text = "Equiped"
	else
		Connection = EquipButton.Activated:Connect(function()
			ReplicatedStorage.Event.ChangeCharacter:FireServer(CharacterName)
			Connection:Disconnect()
			EquipButton.Text = "Equiped"
			ClientData.Data["NextbotEquiped"] = CharacterName
		end)
		EquipButton.Text = "Equip"
		table.insert(Connections, Connection)
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
	ClearConnections(Connections)

	RigAnimator.RigVisible()
	ViewportFrame.Visible = true
	RigAnimator.AbilityButtonToggle(false)
	Structure.TextLabel.Text = EmoteInfo[EmoteName]["Description"]
	EmotePlayer.Play(EmoteName, RigUI.ReturnAnimator())
	Structure.Equip.Text = "Equip"
	local Connection
	Connection = Structure.Equip.Activated:Connect(function()
		Inventory.Enabled = false
		ViewportFrame.Visible = false

		print(ClientData.Data)
		EmoteScript.ChangeEmote(EmoteName)
	end)
	table.insert(Connections, Connection)
end
function InventoryUi.Disable()
	print("DisablePLs")
	Inventory.Enabled = false
	DeleteEverying()
	ClearConnections(Connections)
	RigAnimator.RigInVisible()
	ViewportFrame.Visible = false
end
-------------------------------------------------- BUTTONS
return InventoryUi
