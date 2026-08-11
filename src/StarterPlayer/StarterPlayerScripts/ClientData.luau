local ClientData = {}
local DataEvent
ClientData.Data = {}
function ClientData.activate()
	print("Ich bin Unique")
	DataEvent = game.ReplicatedStorage.ClientData.GiveClientData.OnClientEvent:Connect(function(Data)
		ClientData.Data = Data
		DataEvent:Disconnect()
	end)
end

return ClientData
