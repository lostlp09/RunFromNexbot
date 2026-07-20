local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local uip = game:GetService("UserInputService")
local Camera = game.Workspace:WaitForChild("Camera")
local Ability1 = { lastused = -15, cooldown = 3, Name = "", first_or_second = 1 }
local Ability2 = { lastused = -15, cooldown = 3, Name = "", first_or_second = 1 }
local Ability3 = { lastused = -15, cooldown = 3, Name = "", first_or_second = 1 }
local Abilitys = { Ability1, Ability2, Ability3 }
local player = game.Players.LocalPlayer
local Tweenservice = game:GetService("TweenService")
local localAbilitys = require(ReplicatedStorage.Shared.local_abilitys.abilitys)
local buttoncreator = require(ReplicatedStorage.Shared.local_abilitys.localIcons)
local tweenproperties = {
	["AspectRatio"] = 0.01,
}
game.ReplicatedStorage.Nextbot.Abilitysrequestforclient.getCamerarot.OnClientInvoke = function()
	print("cool")
	return Camera.CFrame.LookVector
end

local function Attack1(currentTime)
	local cooldown = 0
	if type(Ability1.cooldown) == "table" then
		cooldown = Ability1.cooldown[Ability1.first_or_second]
	else
		cooldown = Ability1.cooldown
	end
	print(currentTime, Ability1.lastused, cooldown)
	if currentTime - Ability1.lastused >= cooldown then
		ReplicatedStorage.Nextbot.Ability:FireServer("Ability1")
	end
end
local function Attack2(currentTime)
	local cooldown = 0
	if type(Ability2.cooldown) == "table" then
		cooldown = Ability2.cooldown[Ability2.first_or_second]
	else
		cooldown = Ability2.cooldown
	end
	if currentTime - Ability2.lastused >= cooldown then
		game.ReplicatedStorage.Nextbot.Ability:FireServer("Ability2")
	end
end

local function Attack3(currentTime)
	local cooldown = 0
	if type(Ability3.cooldown) == "table" then
		cooldown = Ability3.cooldown[Ability3.first_or_second]
	else
		cooldown = Ability3.cooldown
	end
	if currentTime - Ability3.lastused >= cooldown then
		game.ReplicatedStorage.Nextbot.Ability:FireServer("Ability3")
	end
end
local Attacks = { Attack1, Attack2, Attack3 }
uip.InputBegan:Connect(function(input)
	if player.Team ~= Teams.Nextbot then
		return
	end
	if Ability1.Name == "" then
		return
	end
	local currentTime = os.clock()
	if input.KeyCode == Enum.KeyCode.E then
		Attack1(currentTime)
	end
	if input.KeyCode == Enum.KeyCode.Q then
		Attack2(currentTime)
	end
	if input.KeyCode == Enum.KeyCode.B then
		Attack3(currentTime)
	end
end)
game.ReplicatedStorage.localnextbotevents.giveproperties.OnClientEvent:Connect(
	function(Ability1cf, Ability2cf, Ablity3cf)
		for i, Ability in { Ability1cf, Ability2cf, Ablity3cf } do
			local Ui: Frame = buttoncreator.createui(player, i, Ability.Name)
			local button = Ui:FindFirstChild("Button")
			Abilitys[i].Button = Ui
			button.MouseButton1Up:Connect(function()
				local currentTime = os.clock()
				Attacks[i](currentTime)
			end)

			local variable = nil
			if Ability.cooldown2 ~= nil then
				Abilitys[i].TimeUntilAutoBack = Ability.TimeUntilAutoBack
				print(Abilitys[i].TimeUntilAutoBack)
				Abilitys[i].first_or_second = 1
				variable = { Ability.cooldown, Ability.cooldown2 }
			else
				variable = Ability.cooldown
			end
			print(variable, Abilitys[i])
			Abilitys[i].Name = Ability.Name
			Abilitys[i].cooldown = variable
		end
	end
)

game.ReplicatedStorage.runlocalabiltys.OnClientEvent:Connect(function(ability: string, other)
	for _, value in Abilitys do
		if value.Name == ability then
			value.lastused = os.clock()
			local TweenInfoprogress
			local scaleitem = value.Button.progressbar.UIAspectRatioConstraint

			if type(other) == "boolean" then
				print("super_es_klappt")
				if other then
					value.first_or_second = 1
					value.Button.TimeUntilBack.Visible = false
				else
					task.spawn(function()
						value.Button.TimeUntilBack.Visible = true
						for i = value.TimeUntilAutoBack, 1, -1 do
							value.Button.TimeUntilBack.Text = tostring(i)
							task.wait(1)
						end
						value.Button.TimeUntilBack.Visible = false
					end)
					value.first_or_second = 2
				end
				TweenInfoprogress = TweenInfo.new(
					value.cooldown[value.first_or_second],
					Enum.EasingStyle.Linear,
					Enum.EasingDirection.In,
					0,
					false,
					0
				)
			end
			if TweenInfoprogress == nil then
				TweenInfoprogress =
					TweenInfo.new(value.cooldown, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)
			end
			task.spawn(function()
				scaleitem.AspectRatio = 5.742
				scaleitem.Parent.Visible = true
				local Tween = Tweenservice:Create(scaleitem, TweenInfoprogress, tweenproperties)
				Tween:Play()
			end)

			break
		end
	end
	localAbilitys[ability](player, other)
end)
game.ReplicatedStorage.localnextbotevents.ResetCamerOffset.OnClientEvent:Connect(function()
	if player.Character then
		local humanoid: Humanoid = player.Character:FindFirstChild("Humanoid")
		humanoid.CameraOffset = Vector3.zero
	end
end)
