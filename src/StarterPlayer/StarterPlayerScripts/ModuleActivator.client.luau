local player = game.Players.LocalPlayer
for _, object in player.PlayerScripts.Rojo_Scripts:GetChildren() do
	if object:IsA("ModuleScript") then
		local Script = require(object)
		if type(Script.activate) == "function" then
			Script.activate()
		end
	end
end
