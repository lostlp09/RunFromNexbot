local Shop = {}
local ClientData = require(script.Parent.Parent.ClientData)
local NextBotUiInfo = require(script.Parent.NextbotUiInfo)
local EmoteUiInfo = require(script.Parent.EmoteInfo)
local NextbotFrame = game.ReplicatedStorage.Ui:FindFirstChild("InventoryPresets"):FindFirstChild("Nexbotselect")
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
function Shop.DisableUi()
	Shop.DeleteAllObjects()
	ShopScreenUi.Enabled = false
	RigUI.DisableViewPort()
end

local function Purchase(Itemtype, key, Connection)
	local AllowedToBuy = game.ReplicatedStorage.Event.RemoteFunction.Purchase:InvokeServer(Itemtype, key)
	if AllowedToBuy then
		if Itemtype == "Character" then
			ClientData.Data.NextbotOwned[key] = true
		elseif Itemtype == "Emote" then
			ClientData.Data.EmoteOwned[key] = true
		end

		Structure.Equip.Text = "Owned"
		Connection:Disconnect()
		print("purchase Worked")
		PurchaseButtonConnection:Disconnect()
	else
		print("Purchase failed")
	end
end
local function OpenmoreDetailed(What, Key, Connection)
	if PurchaseButtonConnection then
		PurchaseButtonConnection:Disconnect()
	end
	PurchaseButtonConnection = Structure.Equip.MouseButton1Up:Connect(function()
		Purchase(What, Key, Connection)
	end)
	RigUI.EnableViewPort()
	if What == "Character" then
		RigUI.RigInVisible()
		print("Viewport Enabled")
		RigUI.AbilityButtonToggle(true)
		Structure.Ability1.Image = NextBotUiInfo[Key]["AbilityIcons"][1]
		Structure.Ability2.Image = NextBotUiInfo[Key]["AbilityIcons"][2]
		Structure.Ability3.Image = NextBotUiInfo[Key]["AbilityIcons"][3]
		Structure.Equip.Text = "Buy"
		Structure.TextLabel.Text = NextBotUiInfo[Key]["Description"]
		Structure.PriceTag.Text = tostring(NextBotUiInfo[Key]["CoinPrice"])
		RigUI.NextbotTexture(NextBotUiInfo[Key]["Icon"])
	elseif What == "Emote" then
		RigUI.playAnimation(EmoteUiInfo[Key].Emote)
		RigUI.RigVisible()
		Structure.Equip.Text = "Buy"
	end
end

function Shop.LoadCharacters()
	if not ClientData.Data then
		return
	end
	CurrentOpen = "Character"
	Shop.DeleteAllObjects()
	for key, value in NextBotUiInfo do
		local Clone = NextbotFrame:Clone()
		Clone.Icon.Text.Text = key
		Clone.Parent = ScrollFrame
		table.insert(Objects, Clone)
		print(ClientData.Data)
		if ClientData.Data["NextbotOwned"][key] then
			print("owned")
			---make already pruchased thing here
		else
			local Connection
			Connection = Clone:FindFirstChild("Button").MouseButton1Up:Connect(function()
				OpenmoreDetailed("Character", key, Connection)
				table.insert(ButtonConnections, Connection)
			end)
		end
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
		print("State")
		ViewportFrame.Visible = false
		Structure.PriceTag.Visible = true
		ShopScreenUi.Enabled = not isOn
		print(CurrentOpen)
		State[CurrentOpen]()
	end
end
function Shop.LoadEmotes()
	if not ClientData.Data then
		return
	end
	Shop.DeleteAllObjects()
	RigUI.AbilityButtonToggle(false)
	for key, value in EmoteUiInfo do
		local Clone = EmoteFrame:Clone()
		Clone.Parent = ScrollFrame
		table.insert(Objects, Clone)
		Clone.Icon.Text.Text = key
		if ClientData.Data["EmoteOwned"][key] then
			print("owned")
			---make already pruchased thing here
		else
			local Connection
			Connection = Clone:FindFirstChild("Button").MouseButton1Up:Connect(function()
				OpenmoreDetailed("Emote", key, Connection)
				table.insert(ButtonConnections, Connection)
			end)
		end
	end
end

function Shop.LoadRobuxShop()
	Shop.DeleteAllObjects()
	local Ui = GamepassShopUi:Clone()
	Ui.Parent = ScrollFrame
	if not ClientData.Data then
		return
	end
	CurrentOpen = "GamePassShop"

	for _, value in Ui.NormalItems:GetChildren() do
		if not value:IsA("Frame") then
			continue
		end
		local Id = value.Id.Value
		print(Id)
		local Info = MarketPlaceService:GetProductInfoAsync(Id, Enum.InfoType.Product)
		print(Id)
		print(Info)
		value.Price.Text = tostring(Info["PriceInRobux"])
		print(value:GetChildren())
		Structure.TextLabel.Text = Info["Name"]
		value:FindFirstChild("Button").MouseButton1Up:Connect(function()
			Shop.PurchaseItem(value.Id.Value)
		end)
	end
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

player.PlayerGui.ShopUi.Categorybar.CharacterFrame.Button.MouseButton1Down:Connect(function()
	Shop.LoadCharacters()
	local Grid = ScrollFrame:FindFirstChild("UIGridLayout")
	if not Grid then
		local OldShop = ScrollFrame:FindFirstChild("GamePassShop")
		OldShop:Destroy()
		local Clone = GridLayout:Clone()
		Clone.Parent = ScrollFrame
	end
end)
player.PlayerGui.ShopUi.Categorybar.EmoteFrame.Button.MouseButton1Up:Connect(function()
	Shop.LoadEmotes()
	local Grid = ScrollFrame:FindFirstChild("UIGridLayout")
	if not Grid then
		local OldShop = ScrollFrame:FindFirstChild("GamePassShop")
		OldShop:Destroy()
		local Clone = GridLayout:Clone()
		Clone.Parent = ScrollFrame
	end
end)
player.PlayerGui.ShopUi.Categorybar.RobuxShop.Button.MouseButton1Up:Connect(function()
	print("ShopButton")
	Shop.LoadRobuxShop()
	local Grid = ScrollFrame:FindFirstChild("UIGridLayout")
	if Grid then
		Grid:Destroy()
	end
end)

return Shop
