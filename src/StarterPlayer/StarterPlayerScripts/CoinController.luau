local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local module = {}
local player = Players.LocalPlayer
local CurrencyTextLabel: TextLabel = player.PlayerGui:WaitForChild("LobbyGui"):WaitForChild("Frame").Currency

function module.activate()
	ReplicatedStorage.Event.GivePlayerCurrentCurrency.OnClientEvent:Connect(function(Tokens)
		CurrencyTextLabel.Text = Tokens
	end)
end

function module.setCoins(amount: number)
	print("Coins setted")
	CurrencyTextLabel.Text = tostring(amount)
end

return module
