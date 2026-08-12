local Purchase = {}
local NextBotPrices = require(script.NexbotPrice)
local ServerStorage = game:GetService("ServerStorage")
local EmotePrices = require(script.EmotePrice)
local PlayerData = require(ServerStorage.Rojo_Scripts.Playeradded.PlayerData)
local SaveData = require(ServerStorage.Rojo_Scripts.Playeradded.Save)
local MarketPlaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProductPurhcases = {

	[3608157385] = function(UserId)
		Purchase.CurrencyBought(UserId, 500)
	end,
	[3703384846] = function(UserId)
		Purchase.CurrencyBought(UserId, 100)
	end,
	[3703386475] = function(UserId)
		Purchase.CurrencyBought(UserId, 50)
	end,
}
function Purchase.activate()
	MarketPlaceService.PromptProductPurchaseFinished:Connect(function(userId, id, IsPurchased)
		if IsPurchased then
			ProductPurhcases[id](userId)
		end
	end)
	ReplicatedStorage.Event.ChangeCharacter.OnServerEvent:Connect(function(player, Key)
		if PlayerData[player.UserId]["NextbotOwned"] == Key then
			PlayerData[player.UserId]["NextEquiped"] = Key
		end
	end)
end
function Purchase.CurrencyBought(ID: number, amount)
	print(PlayerData[ID]["Currency"], "amount")
	PlayerData[ID]["Currency"] += amount
	print(PlayerData[ID]["Currency"], "amount")
	local Player = Players:GetPlayerByUserId(ID)
	task.spawn(function()
		SaveData.SaveData(Player, PlayerData[ID])
	end)
	ReplicatedStorage.Event.GivePlayerCurrentCurrency:FireClient(Player, PlayerData[ID]["Currency"])
end
game.ReplicatedStorage.Event.RemoteFunction.Purchase.OnServerInvoke = function(player: Player, Itemtype, Key)
	print("Wirst du ausgefphrt", Itemtype)

	if Itemtype == "Character" then
		if
			PlayerData[player.UserId]["Currency"] - NextBotPrices[Key] >= 0
			and PlayerData[player.UserId]["NextbotOwned"][Key] == false
		then
			PlayerData[player.UserId]["Currency"] -= NextBotPrices[Key]
			ReplicatedStorage.Event.GivePlayerCurrentCurrency:FireClient(player, PlayerData[player.UserId]["Currency"])
			print("Player has enough Money Peace")
			PlayerData[player.UserId]["NextbotOwned"][Key] = true
			print(PlayerData)
			task.spawn(function()
				SaveData.SaveData(player, PlayerData[player.UserId])
			end)

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
			ReplicatedStorage.Event.GivePlayerCurrentCurrency:FireClient(player, PlayerData[player.UserId]["Currency"])
			task.spawn(function()
				SaveData.SaveData(player, PlayerData[player.UserId])
			end)

			return true
		else
			print(PlayerData)
			print("Player does not have enough Money or he Owns already")
			return false
		end
	else
		print("Something went wrong")
		return false
	end
end

return Purchase
