local ClientData = {}
local DataEvent

DataEvent = game.ReplicatedStorage.ClientData.GiveClientData.OnClientEvent:Connect(function(Data)
	ClientData.Data = Data
	DataEvent:Disconnect()
end)

return ClientData
