local abilityicon = {}

function abilityicon.createui(player: Player, index, Ability)
	local originalsize = game.ReplicatedFirst.uiconecept.UiAbilityIcon.Size
	local originalpos = game.ReplicatedFirst.uiconecept.UiAbilityIcon.Position
	local buttonposition =
		UDim2.new(originalpos.X.Scale, 0, originalpos.Y.Scale - (originalsize.Y.Scale + 0.05) * (index - 1), 0) --- (originalsize.Y.Scale) * index,0 )
	local Ui = game.ReplicatedFirst.uiconecept.UiAbilityIcon:Clone()
	Ui.Position = buttonposition
	Ui.Parent = player.PlayerGui:FindFirstChild("AbilityUI")
	print(player, Ui.Parent)
	abilityicon[Ability](Ui)
	return Ui
end

function abilityicon.Beam(ui)
	local imageobject: ImageLabel = ui.Icon
	imageobject.Image = "rbxassetid://11375297133"
	local AbilityText: TextLabel = ui:FindFirstChild("AbilityInfo")
	AbilityText.Text = "Beam :)"
end

function abilityicon.ShapeShift(ui)
	local imageobject: ImageLabel = ui.Icon
	imageobject.Image = "rbxassetid://11375297133"
	local AbilityText: TextLabel = ui:FindFirstChild("AbilityInfo")
	AbilityText.Text = "ShapeShift :)"
	local TextLabel: TextLabel = Instance.new("TextLabel")
	TextLabel.Parent = ui
	TextLabel.Position = imageobject.Position + UDim2.new(ui.Position.X.Scale / 2 * -1, 0, -0.3, 0)
	TextLabel.Text = "10"
	TextLabel.Name = "TimeUntilBack"
	TextLabel.Visible = true
	TextLabel.TextSize = 20
	TextLabel.BorderSizePixel = 0
end
function abilityicon.Rocket(ui)
	local imageobject: ImageLabel = ui.Icon
	imageobject.Image = "rbxassetid://11375297133"
	local AbilityText: TextLabel = ui:FindFirstChild("AbilityInfo")
	AbilityText.Text = "Rocket hehehehea"
end
function abilityicon.FieldOfView(ui)
	local imageobject: ImageLabel = ui.Icon
	imageobject.Image = "rbxassetid://11375297133"
	local AbilityText: TextLabel = ui:FindFirstChild("AbilityInfo")
	AbilityText.Text = "I can Blind Enemys im tuff"
end
function abilityicon.PorkCall(ui)
	local imageobject: ImageLabel = ui.Icon
	imageobject.Image = "rbxassetid://11375297133"
	local AbilityText: TextLabel = ui:FindFirstChild("AbilityInfo")
	AbilityText.Text = "Call"
end

return abilityicon
