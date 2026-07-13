local Purchase = {}
local NextBotPrices = require(script.NexbotPrice)
local ServerStorage = game:GetService("ServerStorage")
local EmotePrices = require(script.EmotePrice)
local PlayerData = require(ServerStorage.Rojo_Scripts.Playeradded.PlayerData)
local SaveData = require(ServerStorage.Rojo_Scripts.Playeradded.Save)
local MarketPlaceService = game:GetService("MarketplaceService")
local ProductPurhcases = {

	[3608157385] = function(x)
		Purchase.CurrencyBought(x, 100)
	end,
}

function Purchase.CurrencyBought(ID: number, amount)
	print(PlayerData[ID]["Currency"], "amount")
	PlayerData[ID]["Currency"] += amount
	print(PlayerData[ID]["Currency"], "amount")
end
game.ReplicatedStorage.Event.RemoteFunction.Purchase.OnServerInvoke = function(player: Player, Itemtype, Key)
	print("Wirst du ausgefphrt", Itemtype)

	if Itemtype == "Character" then
		if
			PlayerData[player.UserId]["Currency"] - NextBotPrices[Key] >= 0
			and PlayerData[player.UserId]["NextbotOwned"][Key] == false
		then
			PlayerData[player.UserId]["Currency"] -= NextBotPrices[Key]
			print("Player has enough Money Peace")
			PlayerData[player.UserId]["NextbotOwned"][Key] = true
			print(PlayerData)
			SaveData.SaveData(player, PlayerData[player.UserId])
			return true
		else
			print(PlayerData)
			print("Player does not have enough Money or he Owns already")
			return false
		end
	elseif Itemtype == "Emote" then
		if
			PlayerData[player.UserId]["Currency"] - EmotePrices[Key] >= 0
			and PlayerData[player.UserId]["EmoteOwned"][Key] == false
		then
			PlayerData[player.UserId]["Currency"] -= EmotePrices[Key]
			print("Player has enough Money Peace")
			PlayerData[player.UserId]["EmoteOwned"][Key] = true
			print(PlayerData)
			SaveData.SaveData(player, PlayerData[player.UserId])
			return true
		else
			print(PlayerData)
			print("Player does not have enough Money or he Owns already")
			return false
		end
	end
end
MarketPlaceService.PromptProductPurchaseFinished:Connect(function(userId, id, IsPurchased)
	if IsPurchased then
		ProductPurhcases[id](userId)
	end
end)

return Purchase
