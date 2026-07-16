local Reuseableabilitys = {}
Reuseableabilitys.__index = Reuseableabilitys

Reuseableabilitys.Data = { ShapeShift = { cooldown = 15, Name = "ShapeShift", cooldown2 = 3, TimeUntilAutoBack = 10 } }

function Reuseableabilitys.new(Ability: string, classproperties)
	if Reuseableabilitys[Ability] == nil then
		return false
	end
	local self = setmetatable({}, Reuseableabilitys)
	self.classproperties = classproperties
	self.last_used = -15
	self.running = false
	self.reuse = false
	self.config = Reuseableabilitys.Data[Ability]
	self.cooldown = self.config.cooldown
	self.cooldown2 = self.config.cooldown2
	self.Ability = Reuseableabilitys[Ability]
	function self.RunAbility()
		local currenttime = os.clock()
		if self.reuse then
			print("reuse")
			if currenttime - self.last_used >= self.cooldown2 then
				print("Ability für REUSE")

				self.last_used = currenttime
				task.spawn(function()
					self.Ability(classproperties, self.reuse, self)
				end)
			end
		else
			local differenz = currenttime - self.last_used
			print(differenz)
			if differenz >= self.cooldown then
				self.last_used = currenttime
				print("ability_For_Use")
				task.spawn(function()
					self.Ability(classproperties, self.reuse, self)
				end)
			end
		end
	end
	return self
end

-------------------------------------------------------------------------------Attacks

function Reuseableabilitys.ShapeShift(classproperties, SecondAbility, abilityproperties)
	local player: Player = classproperties.player
	local Character = player.Character
	local Beam = Character:WaitForChild("HumanoidRootPart"):WaitForChild("Beam")
	local root = Character:FindFirstChild("HumanoidRootPart")
	local humanoid: Humanoid = Character:FindFirstChild("Humanoid")
	local noobcolor = game.ReplicatedStorage.noobbodycolor
	print(abilityproperties)
	local playerservice = game:GetService("Players")
	local function makeplayerinv(player)
		local Invisiblecostumes = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
		for _, part in player.Character:GetChildren() do
			if part:IsA("Accessory") then
				part:Destroy()
			elseif table.find(Invisiblecostumes, part.Name) ~= nil then
				part.Transparency = 1
			end
		end
	end
	local function makeplayervis(player)
		local Invisiblecostumes = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
		for _, part in player.Character:GetChildren() do
			if table.find(Invisiblecostumes, part.Name) ~= nil then
				part.Transparency = 0
			end
		end
	end
	local function ColorChanger(playercolor: BodyColors, bodycolors: BodyColors)
		playercolor.LeftArmColor = bodycolors.LeftArmColor
		playercolor.RightArmColor = bodycolors.RightArmColor
		playercolor.LeftLegColor = bodycolors.LeftLegColor
		playercolor.RightLegColor = bodycolors.RightLegColor
		playercolor.HeadColor = bodycolors.HeadColor
		playercolor.TorsoColor = bodycolors.TorsoColor
	end
	local function Secondbilityfunc(player)
		print("second function ?")
		local Character = player.Character
		makeplayerinv(player)
		game.ReplicatedStorage.runlocalabiltys:FireClient(classproperties.player, "ShapeShift", true)
		Beam.Name = "Beam"
		Beam.Enabled = true
		print(classproperties)
		humanoid.WalkSpeed = classproperties["speed"]
		Character.Rojo_Scripts:FindFirstChild("othermovment").Enabled = false
		game.ReplicatedStorage.playeranimation.disableanimation:FireClient(player)
		abilityproperties.reuse = false
		task.delay(1, function()
			abilityproperties.running = false
		end)
	end
	abilityproperties.reuse = not abilityproperties.reuse
	if not SecondAbility then
		game.ReplicatedStorage.runlocalabiltys:FireClient(classproperties.player, "ShapeShift", false)
		abilityproperties.running = true
		local Survivors = {}
		for _, Enemy: Player in game.Players:GetChildren() do
			if Enemy.Team == game.Teams.Survivor then
				table.insert(Survivors, Enemy.UserId)
			end
		end
		local bodycolor: BodyColors = Character:FindFirstChild("Body Colors")
		humanoid.WalkSpeed = 32
		task.wait(0.5)
		Beam.Enabled = false
		makeplayervis(player)
		Character.Rojo_Scripts:FindFirstChild("othermovment").Enabled = true
		if #Survivors < 1 then
			ColorChanger(bodycolor, noobcolor)
			local Shirt: Shirt = Character:FindFirstChild("Shirt")
			local Pants: Pants = Character:FindFirstChild("Pants")
			Shirt.ShirtTemplate = ""
			Pants.PantsTemplate = ""
		else
			print(Survivors)
			local randomindex = math.random(1, #Survivors)
			local randomplayer: number = Survivors[randomindex]
			print(randomplayer)
			local humanDescription = playerservice:GetHumanoidDescriptionFromUserIdAsync(5412018595) --player.UserId //Code doesnt work because it doesnt work with test acc i guess lol
			humanoid:ApplyDescriptionAsync(humanDescription, Enum.AssetTypeVerification.Default)
		end
		task.delay(10, function()
			if abilityproperties.reuse then
				Secondbilityfunc(player)
			end
		end)
	else
		Secondbilityfunc(player)
	end
end

return Reuseableabilitys
