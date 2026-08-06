local ContentProvider = game:GetService("ContentProvider")
local module = {}
function module.LoadContent()
	for _, Table in module do
		if type(Table) == "table" then
			ContentProvider:PreloadAsync(Table)
		else
			continue
		end
	end
end
module.Emotes = { 109359932912715, 110335743551355, 99250503928355 }

module.Images = {}
--Shuffle -ChillDance -  Crazy
module.Audio = { 123048251088564, 1835394220, 79261923361270 }

return module
