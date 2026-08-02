local ReplicatedStorage = game:GetService("ReplicatedStorage")
local movment = {}
local playerstatus = {}
local MovementShared = require(ReplicatedStorage:WaitForChild("Shared").Movment)
print("do you even run")
MovementShared.RunFunction()

function movment.addplayer(player)
	playerstatus[player.UserId] = table.clone({ sliding = false, sprinting = false, lastsliding = 0 })
	print(playerstatus)
end

return movment
