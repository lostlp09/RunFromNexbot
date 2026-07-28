local StarterPlayer = game:GetService("StarterPlayer")
local NextbotUiInfo = require(StarterPlayer.StarterPlayerScripts.Rojo_Scripts.Ui.NextbotUiInfo)
local abilityicon = {}

function abilityicon.createui(player: Player, index, Ability, CharacterName)
	local y = 0.7

	if index == 2 then
		y = 0.5
	end

	local buttonposition = UDim2.fromScale(0.5 + index / 10, y) --- (originalsize.Y.Scale) * index,0 )
	local Ui = game.ReplicatedStorage.Ui:FindFirstChild("Ability").AbilityButton
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
	AbilityText.Text = "ShapeShift"
	local TextLabel: TextLabel = Instance.new("TextLabel")
	TextLabel.Parent = ui
	TextLabel.Position = imageobject.Position + UDim2.fromScale(ui.Position.X.Scale / 2 * -1, -0.3)
	TextLabel.Text = "10"
	TextLabel.Name = "Cooldown"
	TextLabel.Visible = true
	TextLabel.TextSize = 20
	TextLabel.BorderSizePixel = 0
	TextLabel.Visible = false
end
function abilityicon.Rocket(ui, index, Name)
	local imageobject: ImageButton = ui.Canvas.ImageButton
	imageobject.Image = NextbotUiInfo[Name].AbilityIcons[index]
	local AbilityText: TextLabel = ui:FindFirstChild("AbilityName")
	AbilityText.Text = Name
end
function abilityicon.FieldOfView(ui, index, Name)
	local imageobject: ImageButton = ui.Canvas.ImageButton
	imageobject.Image = NextbotUiInfo.Royal.AbilityIcons[index]
	local AbilityText: TextLabel = ui:FindFirstChild("AbilityName")
	AbilityText.Text = Name
end
function abilityicon.PorkCall(ui, index, Name)
	local imageobject: ImageButton = ui.Canvas.ImageButton
	imageobject.Image = NextbotUiInfo[Name].AbilityIcons[index]
	local AbilityText: TextLabel = ui:FindFirstChild("AbilityName")
	AbilityText.Text = Name
end
function abilityicon.SpeedBoost(ui, index, Name)
	local imageobject: ImageButton = ui.Canvas.ImageButton
	print(NextbotUiInfo[Name], Name, NextbotUiInfo)
	imageobject.Image = NextbotUiInfo[Name].AbilityIcons[index]
	local AbilityText: TextLabel = ui:FindFirstChild("AbilityName")
	AbilityText.Text = Name
end
function abilityicon.Thunder(ui, index, Name)
	local imageobject: ImageButton = ui.Canvas.ImageButton

	imageobject.Image = NextbotUiInfo[Name].AbilityIcons[index]
	local AbilityText: TextLabel = ui:FindFirstChild("AbilityName")
	AbilityText.Text = Name
end
return abilityicon
