local Nextbotgiver = {}
local Nextbots = require(script.Parent.Nextbotarray)
local Nextbotclass = require(script.Parent.Nexbotscripts)
Nextbotgiver.Nextbot_player = {}
function Nextbotgiver.addplayer(player: Player, whattype)
	print("ich klappe", Nextbotgiver)
	local array = Nextbots[whattype]
	local nextbot = Nextbotclass.new(player, array[1], array[2], array[3], array[4], array[5], array[6], array[7])
	Nextbotgiver.Nextbot_player[player.UserId] = nextbot
end
function Nextbotgiver.RemoveAll()
	table.clear(Nextbotgiver.Nextbot_player)
end
return Nextbotgiver
