local CoinController = require(script.Parent.CoinController)
local ClientData = {}
local DataEvent
ClientData.Data = {}

function ClientData.activate()
	print("Ich bin Unique")
	DataEvent = game.ReplicatedStorage.ClientData.GiveClientData.OnClientEvent:Connect(function(Data)
		ClientData.Data = Data
		CoinController.activate()
		CoinController.setCoins(ClientData.Data["Currency"])
		DataEvent:Disconnect()
	end)
end

return ClientData
