local ServerStorage = game:GetService("ServerStorage")
local Nextbot = {}

local NormalAbilitys = require(ServerStorage.Rojo_Scripts.ServerAbiltys.Normal_ab)
local ReuseAbility = require(ServerStorage.Rojo_Scripts.ServerAbiltys.reuseab)
function Nextbot.new(player, Name, Texture, walkspeed: number, HasAbilitys: boolean, Ability1, Ability2, Ability3)
	local self = {}
	self.Name = Name
	self.player = player
	self.Name = Name
	self.WalkSpeed = walkspeed
	self.Texture = Texture
	self.HasAbilitys = HasAbilitys
	print(Ability1)
	self.Ability1 = NormalAbilitys.new(Ability1, self) or ReuseAbility.new(Ability1, self)
	self.Ability2 = NormalAbilitys.new(Ability2, self) or ReuseAbility.new(Ability2, self)
	self.Ability3 = NormalAbilitys.new(Ability3, self) or ReuseAbility.new(Ability3, self)
	print(self.Ability1)
	if not self.Ability2 then
		print(self.Ability1.config)
		game.ReplicatedStorage.localnextbotevents.giveproperties:FireClient(player, table.clone(self.Ability1.config))
	elseif not self.Ability3 then
		game.ReplicatedStorage.localnextbotevents.giveproperties:FireClient(
			player,
			table.clone(self.Ability1.config),
			table.clone(self.Ability2.config)
		)
	else
		game.ReplicatedStorage.localnextbotevents.giveproperties:FireClient(
			player,
			table.clone(self.Ability1.config),
			table.clone(self.Ability2.config),
			table.clone(self.Ability3.config)
		)
	end
	self.humanoid = self.player.Character:FindFirstChild("Humanoid")
	self.humanoid.WalkSpeed = self.WalkSpeed

	self.attackrequest = game.ReplicatedStorage.Nextbot.Ability.OnServerEvent:Connect(function(player_sended, Ability)
		print(player_sended)
		print(self.player)
		if player_sended ~= self.player then
			return
		end
		if self[Ability] == nil then
			return
		end
		for i, value in { self.Ability1, self.Ability2, self.Ability3 } do
			if value ~= false and value ~= self[Ability] then
				if value.running then
					print("Why", i)
					return
				end
			end
		end
		print("RunAbility")
		self[Ability].RunAbility()
	end)
	self.gamestartet = nil
	self.gamestartet = game.ReplicatedStorage.Start.Event:Connect(function()
		print(self.player)
		local root = self.player.Character:FindFirstChild("HumanoidRootPart")

		local Attachment0 = Instance.new("Attachment")
		local Attachment1 = Instance.new("Attachment")
		Attachment0.CFrame = CFrame.new(0, 8, 0)
		Attachment1.CFrame = CFrame.new(0, -3, 0)
		local Beam = Instance.new("Beam")
		Attachment0.Parent = root
		Attachment1.Parent = root
		Beam.Width0 = 10
		Beam.Width1 = 10
		Beam.TextureSpeed = 0
		Beam.Attachment0 = Attachment0
		Beam.Attachment1 = Attachment1
		Beam.Texture = Texture
		Beam.FaceCamera = true
		Beam.Parent = root
		Beam.Transparency = NumberSequence.new(0, 0)
		self.gamestartet:Disconnect()
	end)

	print(self)
	return self
end
return Nextbot
