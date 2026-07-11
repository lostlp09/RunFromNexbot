local SurvivalStatusApplier = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AbilitySurvconsequence = require(ReplicatedStorage.Shared.local_abilitys.AbilitySurvconsequence)

local StatusEvent: RemoteEvent = ReplicatedStorage:FindFirstChild("Event"):FindFirstChild("StatusApplier")
StatusEvent.OnClientEvent:Connect(function(Status, duration)
	AbilitySurvconsequence.ApplyStatus(Status, duration)
end)

task.wait(3)
AbilitySurvconsequence.ApplyStatus("FieldOfView", 3)
return SurvivalStatusApplier
