local StarterPlayer = game:GetService("StarterPlayer")
local NextbotUiInfo = require(StarterPlayer.StarterPlayerScripts.Rojo_Scripts.Ui.NextbotUiInfo)
local abilityicon = {}

function abilityicon.createui(player: Player, index, Ability, CharacterName)
	local y = 0.7

	if index == 2 then
		y = 0.5
	end

	local buttonposition = UDim2.fromScale(0.5 + index / 10, y) --- (originalsize.Y.Scale) * index,0 )
	local Ui = game.ReplicatedStorage.Ui:FindFirstChild("Ability").AbilityButton:Clone()
	Ui.Position = buttonposition
	Ui.Parent = player.PlayerGui:FindFirstChild("AbilityUI")
	print(player, Ui.Parent)
	abilityicon[Ability](Ui, index, CharacterName)
	return Ui
end

function abilityicon.ShapeShift(ui, index, Name)
	local imageobject: ImageButton = ui.Canvas.ImageButton
	imageobject.Image = NextbotUiInfo[Name].AbilityIcons[index]
	local AbilityText: TextLabel = ui:FindFirstChild("AbilityName")
	AbilityText.Text = NextbotUiInfo[Name].Ability["Ability" .. tostring(index)]
	local TextLabel = ui:FindFirstChild("Cooldown")
	TextLabel.Parent = ui
	TextLabel.Text = "10"
end
function abilityicon.Rocket(ui, index, Name)
	local imageobject: ImageButton = ui.Canvas.ImageButton
	imageobject.Image = NextbotUiInfo[Name].AbilityIcons[index]
	local AbilityText: TextLabel = ui:FindFirstChild("AbilityName")
	AbilityText.Text = NextbotUiInfo[Name].Ability["Ability" .. tostring(index)]
end
function abilityicon.Laugh(ui, index, Name)
	local imageobject: ImageButton = ui.Canvas.ImageButton
	imageobject.Image = NextbotUiInfo.Royal.AbilityIcons[index]
	local AbilityText: TextLabel = ui:FindFirstChild("AbilityName")
	AbilityText.Text = NextbotUiInfo[Name].Ability["Ability" .. tostring(index)]
end
function abilityicon.PorkCall(ui, index, Name)
	local imageobject: ImageButton = ui.Canvas.ImageButton
	imageobject.Image = NextbotUiInfo[Name].AbilityIcons[index]
	local AbilityText: TextLabel = ui:FindFirstChild("AbilityName")
	AbilityText.Text = NextbotUiInfo[Name].Ability["Ability" .. tostring(index)]
end
function abilityicon.SpeedBoost(ui, index, Name)
	local imageobject: ImageButton = ui.Canvas.ImageButton
	print(NextbotUiInfo[Name], Name, NextbotUiInfo)
	imageobject.Image = NextbotUiInfo[Name].AbilityIcons[index]
	local AbilityText: TextLabel = ui:FindFirstChild("AbilityName")
	AbilityText.Text = NextbotUiInfo[Name].Ability["Ability" .. tostring(index)]
end
function abilityicon.Thunder(ui, index, Name)
	local imageobject: ImageButton = ui.Canvas.ImageButton

	imageobject.Image = NextbotUiInfo[Name].AbilityIcons[index]
	local AbilityText: TextLabel = ui:FindFirstChild("AbilityName")
	AbilityText.Text = NextbotUiInfo[Name].Ability["Ability" .. tostring(index)]
end
return abilityicon
