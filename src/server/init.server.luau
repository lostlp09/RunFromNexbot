function activatescripts(root)
	for _, value: Instance in root:GetChildren() do
		if value:IsA("Folder") then
			activatescripts(value)
		elseif value:IsA("ModuleScript") then
			local module = require(value)
			if type(module.activate) == "function" then
				module.activate()
			end
		end
	end
end
activatescripts(game.ServerStorage)
