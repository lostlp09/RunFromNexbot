local PlayerData = {}
local Saveclass = require(script.Parent.Save)
local Startertable = 
	{	["Wins"] = 0 ,
		["Nextbotequiped"] = "Peace",
		["NextbotOwned"]  = {["Royal"] = false},
		["EmoteOwned"] = {["Griddy"] = true,["Worm"] = false},
		["EmoteEquiped"] = {["1"]= false,["2"] = false,["3"]= false,["4"] = false},
		["Currency"] = 1000
	}

local function DeepCopy(GivenTable)
	local Tabel = {}
	for Key,value in pairs(GivenTable) do
		if type(value) == "table" then
			Tabel[Key] = DeepCopy(value)
		else
			Tabel[Key] = value
		end
	end
	return Tabel

end
local function DataCheck(TableToCheck,PerfektTable)
	local EndTable = {}
	for Key,value in pairs(PerfektTable) do
		if TableToCheck[Key] ~=nil  then
			if type(value) == "table" then
				EndTable[Key] = DataCheck(TableToCheck[Key],value)
			else
				EndTable[Key] = TableToCheck[Key]
			end
		else
			if type(value) == "table" then
				EndTable[Key] = DeepCopy(value)
			else
				EndTable[Key] = value
			end
		end
	end
	return EndTable
end
function PlayerData.addplayer(player:Player,Data)
	if Data then
		print(Data)
		PlayerData[player.UserId] = DataCheck(Data,Startertable)
	else
		PlayerData[player.UserId] = DeepCopy(Startertable)
	end
	Saveclass.SaveData(player,PlayerData[player.UserId])
	print(PlayerData[player.UserId])
	game.ReplicatedStorage.ClientData.GiveClientData:FireClient(player,PlayerData[player.UserId])
end
return PlayerData
