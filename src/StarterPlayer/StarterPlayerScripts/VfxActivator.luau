local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Vfxplayer = require(ReplicatedStorage.Shared.Vfxplayer)
local module = {}
local VFXEmitter: RemoteEvent = ReplicatedStorage.Event:WaitForChild("VFXEmitter")

function module.activate()
	VFXEmitter.OnClientEvent:Connect(function(Name, Position)
		print("yo Ich wurde ausgeführt")
		Vfxplayer[Name](Position)
	end)
end

return module
