local Data = {}
local DataStore = game:GetService("DataStoreService")
local PlayerData = DataStore:GetDataStore("PlayerData")
local BackupData = DataStore:GetDataStore("Backup")
function Data.activate()

end

function Data.LoadData(player:Player)
	local UserId = player.UserId
	local data
	local sucess,errorMessage = pcall(function ()
		data = PlayerData:GetAsync(player.UserId)
	end)
	if sucess then
		print("it Worked")
		return data


	elseif errorMessage then
		print(errorMessage)
		player:Kick("Data could not be loaded ,just Rejoin")
	end

end

function Data.SaveData(player:Player,data)

	local UserId = player.UserId
	local sucess,errorMessage = pcall(function ()
		PlayerData:SetAsync(UserId,data)
	end)
	if sucess then
		print("it worked")
	else
		print(errorMessage)
	end



end
function Data.DeleteData(player:Player)
	PlayerData:RemoveAsync(player.UserId)
	
	
end
return Data
