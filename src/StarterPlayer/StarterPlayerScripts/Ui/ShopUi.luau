local Shop = {}
local ClientData = require(script.Parent.Parent.ClientData)
local NextBotUiInfo = require(script.Parent.NextbotUiInfo)
local EmoteUiInfo = require(script.Parent.EmoteInfo)
local NextbotFrame = game.ReplicatedStorage.Ui:FindFirstChild("InventoryPresets"):FindFirstChild("NextbotSelect")
local EmoteFrame = game.ReplicatedStorage.Ui:FindFirstChild("InventoryPresets").EmoteSelect
local ShopScreenUi = game.Players.LocalPlayer.PlayerGui.ShopUi
local ScrollFrame = ShopScreenUi.Buttonloader
local RigUI = require(script.Parent.RigUI)
local ButtonConnections = {}
local CurrentOpen = "Character"
local PurchaseConnections = {}
local player = game.Players.LocalPlayer
local Structure = player.PlayerGui.Rig.ViewportFrame.Structure
local ViewportFrame = Structure.Parent
local PurchaseButtonConnection = nil
local Objects = {}

local GridLayout = game:WaitForChild("StarterGui").ShopUi.Buttonloader.UIGridLayout
local GamepassShopUi = game.ReplicatedStorage.Ui.GamePassShop
local MarketPlaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EmotePlayer = require(ReplicatedStorage.Shared.EmotePlayer.EmotePlayer)
local function Purchase(Itemtype, key, Connection, Instance)
	local AllowedToBuy = game.ReplicatedStorage.Event.RemoteFunction.Purchase:InvokeServer(Itemtype, key)
	if AllowedToBuy then
		if Itemtype == "Character" then
			ClientData.Data.NextbotOwned[key] = true
		elseif Itemtype == "Emote" then
			ClientData.Data.EmoteOwned[key] = true
			print(ClientData.Data)
		end
		Instance.Owned.Visible = true
		Structure.Equip.Text = "Owned"
		Connection:Disconnect()
		PurchaseButtonConnection:Disconnect()
	else
		print("_")
	end
end
local function OpenmoreDetailed(What, Key, Connection, Instance)
	if PurchaseButtonConnection then
		PurchaseButtonConnection:Disconnect()
	end
	PurchaseButtonConnection = Structure.Equip.MouseButton1Up:Connect(function()
		Purchase(What, Key, Connection, Instance)
	end)
	RigUI.EnableViewPort()
	if What == "Character" then
		RigUI.RigInVisible()
		RigUI.AbilityButtonToggle(true)
		Structure.Ability1.Image = NextBotUiInfo[Key]["AbilityIcons"][1]
		Structure.Ability2.Image = NextBotUiInfo[Key]["AbilityIcons"][2]
		if NextBotUiInfo[Key]["AbilityIcons"][3] then
			Structure.Ability3.Image = NextBotUiInfo[Key]["AbilityIcons"][3]
		end
		Structure.Equip.Text = "Buy"
		Structure.TextLabel.Text = NextBotUiInfo[Key]["Description"]
		Structure.PriceTag.Text = tostring(NextBotUiInfo[Key]["CoinPrice"]) .. " Tokens"
		RigUI.NextbotTexture(NextBotUiInfo[Key].Icon)
	elseif What == "Emote" then
		EmotePlayer.Play(Key, RigUI.ReturnAnimator())
		RigUI.RigVisible()
		Structure.PriceTag.Text = tostring(EmoteUiInfo[Key].Price) .. " Tokens"
		Structure.Equip.Text = "Buy"
		Structure.TextLabel.Text = EmoteUiInfo[Key].Description
	end
end
function Shop.DisableUi()
	Shop.DeleteAllObjects()
	ShopScreenUi.Enabled = false
	RigUI.DisableViewPort()
end
function Shop.LoadCharacters()
	ViewportFrame.Visible = false
	if not ClientData.Data then
		return
	end
	CurrentOpen = "Character"
	Shop.DeleteAllObjects()
	for key, value in NextBotUiInfo do
		local Clone = NextbotFrame:Clone()
		Clone.Text.Text = key
		Clone.Icon.Image = "rbxassetid://" .. tostring(NextBotUiInfo[key].Icon)
		Clone.Parent = ScrollFrame
		table.insert(Objects, Clone)
		print(key, ClientData.Data["NextbotOwned"])
		if ClientData.Data["NextbotOwned"][key] then
			Clone.Owned.Visible = true
			print("It worked")
		else
			local Connection
			Connection = Clone:FindFirstChild("Button").MouseButton1Up:Connect(function()
				print("ICH WURDE GEDRÜCKt")
				OpenmoreDetailed("Character", key, Connection, Clone)
				table.insert(ButtonConnections, Connection)
			end)
		end
	end
end

function Shop.LoadEmotes()
	ViewportFrame.Visible = false
	if not ClientData.Data then
		return
	end
	print("Emotes are loading")
	Shop.DeleteAllObjects()
	RigUI.AbilityButtonToggle(false)
	for key, _ in EmoteUiInfo do
		local Clone = EmoteFrame:Clone()
		Clone.Parent = ScrollFrame
		table.insert(Objects, Clone)
		Clone.Text.Text = key
		local Animator = Clone.ViewportFrame.WorldModel.R6.Humanoid.Animator

		EmotePlayer.Play(key, Animator)
		if ClientData.Data["EmoteOwned"][key] then
			Clone.Owned.Visible = true
			---make already pruchased thing here
		else
			local Connection
			Connection = Clone:FindFirstChild("Button").MouseButton1Up:Connect(function()
				OpenmoreDetailed("Emote", key, Connection, Clone)
				table.insert(ButtonConnections, Connection)
			end)
		end
	end
end

function Shop.LoadRobuxShop()
	ViewportFrame.Visible = false
	Shop.DeleteAllObjects()
	local Ui = GamepassShopUi:Clone()
	Ui.Parent = ScrollFrame

	if not ClientData.Data then
		return
	end
	CurrentOpen = "GamePassShop"
	table.insert(Objects, Ui)
	for _, value in Ui.NormalItems:GetChildren() do
		if not value:IsA("Frame") then
			continue
		end
		local Id = value.Id.Value
		task.spawn(function()
			local Info = MarketPlaceService:GetProductInfoAsync(Id, Enum.InfoType.Product)
			value.Price.Text = "\u{E002}" .. tostring(Info["PriceInRobux"])
		end)

		local Connection
		Connection = value:FindFirstChild("Button").MouseButton1Up:Connect(function()
			Shop.PurchaseItem(value.Id.Value)
			table.insert(ButtonConnections, Connection)
		end)
	end
end

local State = {
	["Character"] = Shop.LoadCharacters,
	["Emote"] = Shop.LoadEmotes,
	["GamePassShop"] = Shop.LoadRobuxShop,
}
function Shop.ChangeVisiblity()
	local isOn = ShopScreenUi.Enabled
	if isOn then
		Shop.DisableUi()
	else
		ViewportFrame.Visible = false
		Structure.PriceTag.Visible = true
		ShopScreenUi.Enabled = not isOn
		State[CurrentOpen]()
	end
end
function Shop.activate()
	player.PlayerGui.ShopUi.Categorybar.Character.MouseButton1Down:Connect(function()
		Shop.LoadCharacters()
	end)
	player.PlayerGui.ShopUi.Categorybar.Emotes.MouseButton1Up:Connect(function()
		print("Connection wurde ausgeführt")
		Shop.LoadEmotes()
	end)
	player.PlayerGui.ShopUi.Categorybar.Coins.MouseButton1Up:Connect(function()
		Shop.LoadRobuxShop()
	end)
end

function Shop.PurchaseItem(Id)
	MarketPlaceService:PromptProductPurchase(player, Id)
end
function Shop.DeleteAllObjects()
	for _, Object in Objects do
		Object:Destroy()
	end
	for _, Connection in PurchaseConnections do
		Connection:Disconnect()
	end
	if PurchaseButtonConnection then
		PurchaseButtonConnection:Disconnect()
	end
end

return Shop
