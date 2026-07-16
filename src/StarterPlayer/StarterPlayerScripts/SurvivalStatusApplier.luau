local SurvivalStatusApplier = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AbilitySurvconsequence = require(ReplicatedStorage.Shared.local_abilitys.AbilitySurvconsequence)

local StatusEvent: RemoteEvent = ReplicatedStorage:FindFirstChild("Event"):FindFirstChild("StatusApplier")
local ConsequenceEvent: RemoteEvent = ReplicatedStorage:FindFirstChild("Event"):FindFirstChild("ConsequenceApllier")
StatusEvent.OnClientEvent:Connect(function(Status, duration)
	AbilitySurvconsequence.ApplyStatus(Status, duration)
end)
ConsequenceEvent.OnClientEvent:Connect(function(key)
	print(key, AbilitySurvconsequence.Consequence)
	AbilitySurvconsequence.Consequence[key]()
end)

return SurvivalStatusApplier
