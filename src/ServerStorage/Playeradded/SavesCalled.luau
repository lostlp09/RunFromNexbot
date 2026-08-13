local module = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerData = require(script.Parent.PlayerData)
local Save = require(script.Parent.Save)

function module.activate()
	game:BindToClose(function()
		for _, player in Players:GetPlayers() do
			Save.SaveData(player, PlayerData[player.UserId])
		end
	end)

	ReplicatedStorage.Event.EmoteEquiped.OnServerEvent:Connect(function(player, index, key)
		print("Changed Character Finally")
		print(key, index)
		print("YO ICH WURDE AUSGEFÜHRt")
		if tonumber(index) > 5 then
			return
		end
		PlayerData[player.UserId]["EmoteEquiped"][index] = key
		print(PlayerData[player.UserId])
	end)
	Players.PlayerRemoving:Connect(function(Player: Player)
		Save.SaveData(Player, PlayerData[Player.UserId])
	end)
	ReplicatedStorage.Event.ChangeCharacter.OnServerEvent:Connect(function(player: Player, key)
		if PlayerData[player.UserId]["NextbotOwned"][key] then
			PlayerData[player.UserId]["NextbotEquiped"] = key
		end
	end)
end

return module
