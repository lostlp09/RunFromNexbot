local SurvivorNextbotAlive = {}
SurvivorNextbotAlive.Survivor = {}
SurvivorNextbotAlive.Nextbots = {}

function SurvivorNextbotAlive.SetNextbot(new)
	SurvivorNextbotAlive.Nextbots = new
end
function SurvivorNextbotAlive.SetSurvivor(new)
	SurvivorNextbotAlive.Survivors = new
end
function SurvivorNextbotAlive.GetSurvivor()
	return table.clone(SurvivorNextbotAlive.Survivors)
end
function SurvivorNextbotAlive.GetNextBots()
	return table.clone(SurvivorNextbotAlive.Nextbots)
end
function SurvivorNextbotAlive.Reset()
	table.clear(SurvivorNextbotAlive.Survivors)
	table.clear(SurvivorNextbotAlive.Nextbots)
end

return SurvivorNextbotAlive
