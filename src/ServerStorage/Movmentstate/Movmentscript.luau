local ReplicatedStorage = game:GetService("ReplicatedStorage")
local movment = {}
local playerstatus = {}

local movmentfunctions = require(ReplicatedStorage.Shared.MathForMovment)
local slidecooldown = 3
local nextbotplayer = require(script.Parent.Parent.Nextbots.Nextbotplayer)
local remotefunction = game.ReplicatedStorage:WaitForChild("Playermovment"):WaitForChild("slidfunc")
function movment.addplayer(player)
	playerstatus[player.UserId] = table.clone({ sliding = false, sprinting = false, lastsliding = 0 })
	print(playerstatus)
end

function movment.activate() end

return movment
