local movment = {}
local playerstatus = {}
local movmentfunctions = require(game.ReplicatedStorage:FindFirstChild("Playermovment").mathsformoving)
local slidecooldown = 3
local nextbotplayer = require(script.Parent.Parent.Nextbots.Nextbotplayer)
local remotefunction = game.ReplicatedStorage:WaitForChild("Playermovment"):WaitForChild("slidfunc")
function movment.addplayer(player)
	playerstatus[player.UserId] = table.clone({sliding =false ,sprinting = false,lastsliding = 0})
	print(playerstatus)
end



 

function movment.activate()
	
	remotefunction.OnServerInvoke = function(player:Player)
		print(nextbotplayer.Nextbot_player[player.UserId] )
		if player.Team == game.Teams.Nextbots and  nextbotplayer.Nextbot_player[player.UserId].Name == "CoolGuy" then
			player:Kick("Cheat or bug idk")
		end
		print("slide")
		local character = player.Character
		local humanoid = character:FindFirstChild("Humanoid")
		local root = character:FindFirstChild("HumanoidRootPart")
		if not movmentfunctions.isonfloor(root,12) then return false end
		if os.clock() - playerstatus[player.UserId]["lastsliding"] < slidecooldown then return false end
		playerstatus[player.UserId]["lastsliding"] = os.clock()
		return true
	end
end


return movment
