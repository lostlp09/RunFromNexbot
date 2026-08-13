local NormalAbilitys = {}
NormalAbilitys.__index = NormalAbilitys
local Runservice = game:GetService("RunService")
local PlayerService = game:GetService("Players")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Teams = game:GetService("Teams")
local SoundCreator = require(ReplicatedStorage.Shared.SoundCreator)
local SurvivorNextbotAlive = require(ServerStorage.Rojo_Scripts.gamestartingscripts.SurvivorNextbotAlive)

function NormalAbilitys.new(Ability: string, classproperties)
	if NormalAbilitys[Ability] == nil then
		return false
	end
	local self = setmetatable({}, NormalAbilitys)
	self.classproperties = classproperties
	self.last_used = -15
	self.running = false

	self.config = NormalAbilitys.Data[Ability]
	print(Ability, self.config, NormalAbilitys.Data)
	self.cooldown = self.config.cooldown
	self.Ability = NormalAbilitys[Ability]
	function self.RunAbility()
		local currenttime = os.clock()
		if currenttime - self.last_used >= self.cooldown then
			print(self.config.Name)
			game.ReplicatedStorage.runlocalabiltys:FireClient(classproperties.player, self.config.Name)
			print("runTest")
			self.last_used = currenttime
			task.spawn(function()
				self.Ability(classproperties)
			end)
		end
	end
	return self
end

NormalAbilitys.Data = {
	Rocket = { cooldown = 10, Name = "Rocket", CharacterName = "Royal" },
	Laugh = { cooldown = 20, Name = "Laugh", CharacterName = "Royal" },
	PorkCall = { cooldown = 20, Name = "PorkCall", CharacterName = "Pork" },
	SpeedBoost = { cooldown = 20, Name = "SpeedBoost", CharacterName = "Sanic" },
	Thunder = { cooldown = 20, Name = "Thunder", CharacterName = "Sanic" },
}

function NormalAbilitys.Rocket(playerclassproperties)
	local player: Player = playerclassproperties.player
	local Character = player.Character
	local root = Character:FindFirstChild("HumanoidRootPart")
	local PossibleCandidates = {}
	for _, Enemyplayer: Player in game.Players:GetChildren() do
		print("run my little boy")
		if Enemyplayer.Team == game.Teams.Survivor and Enemyplayer.Character then
			print(Enemyplayer, Enemyplayer.Team, "Very Important")
			table.insert(PossibleCandidates, Enemyplayer)
		end
	end
	for _ = 1, 3, 1 do
		print("Rocket Abfeuern", #PossibleCandidates)
		if #PossibleCandidates < 1 then
			return
		end
		local RandomIndex = math.random(1, #PossibleCandidates)
		local Randomplayer = PossibleCandidates[RandomIndex]
		local EnemyRootpart: BasePart = Randomplayer.Character.HumanoidRootPart
		print(Randomplayer, "is the Random Player")
		local Raycastprop = RaycastParams.new()
		Raycastprop.CollisionGroup = "player"
		local RayCast = game.Workspace:Raycast(
			Vector3.new(EnemyRootpart.Position.X, 200, EnemyRootpart.Position.Z),
			Vector3.new(0, -500, 0),
			Raycastprop
		)
		local RocketModel = game.ReplicatedStorage.Models.Rocket.Rocket:Clone()
		RocketModel.Parent = game.Workspace
		local Rocket = RocketModel.PrimaryPart
		local Killbox = game.ReplicatedStorage.Models.Rocket.DamageBox
		local HitBox: Part = RocketModel.HitBox

		local Indicator = game.ReplicatedStorage.Models.Rocket.Indicator:Clone()
		table.remove(PossibleCandidates, RandomIndex)
		Indicator.Parent = game.Workspace
		print(RayCast)
		local direction = RayCast.Normal
		Indicator:PivotTo(
			CFrame.lookAt(
				Vector3.new(EnemyRootpart.Position.X, RayCast.Position.Y, EnemyRootpart.Position.Z) + direction * 0.1,
				Vector3.new(EnemyRootpart.Position.X, RayCast.Position.Y, EnemyRootpart.Position.Z) + direction
			)
		)
		local PlayerPosition: Vector3 = EnemyRootpart.Position
		local Gravity = workspace.Gravity
		Killbox.CanTouch = true
		local Time = 3

		game.Debris:AddItem(RocketModel, 4)
		local Connection
		local RunServiceCon
		local StarterPosition = root.Position + Vector3.new(0, 10, 0)
		RocketModel:PivotTo(CFrame.new(StarterPosition))
		local StartVelocityY = ((PlayerPosition.Y - StarterPosition.Y) + Gravity * math.pow(Time, 2) * (1 / 2)) / Time
		local Direction = Vector3.new(PlayerPosition.X - StarterPosition.X, 0, PlayerPosition.Z - StarterPosition.Z)
		local Distance = Direction.Magnitude
		local DirectionUnit = Direction.Unit
		local Speed = Distance / Time

		Rocket.AssemblyLinearVelocity = DirectionUnit * Speed + Vector3.new(0, StartVelocityY, 0)
		RunServiceCon = Runservice.Heartbeat:Connect(function()
			if not Rocket then
				RunServiceCon:Disconnect()
			end
			local Velocity = Rocket.AssemblyLinearVelocity
			if Velocity.Magnitude > 0.1 then
				Velocity = Rocket.AssemblyLinearVelocity.Unit
				RocketModel:PivotTo(CFrame.lookAt(Rocket.Position, Rocket.Position + Velocity))
			end
		end)
		local hitregister = false
		Connection = HitBox.Touched:Connect(function(Part)
			if hitregister then
				return
			end
			if Part.Parent.Name == "Rocket" then
				return
			end
			hitregister = true
			Connection:Disconnect()
			print("wie oft wird der Code ausgeführt")
			local Humanoid: Humanoid = Part.Parent:FindFirstChild("Humanoid")
			if Humanoid then
				local playerTouched: Player = PlayerService:GetPlayerFromCharacter(Humanoid.Parent)
				if playerTouched.Team ~= game.Teams.Survivor then
					hitregister = false
					return
				end
			end
			local KillHitBox = Killbox:Clone()
			RocketModel:Destroy()
			Indicator:Destroy()
			KillHitBox.Position = Rocket.Position
			KillHitBox.Parent = game.Workspace
			KillHitBox.Anchored = true
			local Hittplayers = {}
			for _, Enemy in workspace:GetPartsInPart(KillHitBox) do
				local EnemyHumanoid = Enemy.Parent:FindFirstChild("Humanoid")
				if EnemyHumanoid then
					local EnemyPlayer: Player = PlayerService:GetPlayerFromCharacter(EnemyHumanoid.Parent)
					if Hittplayers[EnemyPlayer.UserId] then
						continue
					end
					Hittplayers[EnemyPlayer.UserId] = true
					EnemyHumanoid.Health = 0
				end
			end
			KillHitBox:Destroy()
		end)
		task.delay(3, function()
			if Connection then
				Connection:Disconnect()
			end
		end)
		game.Debris:AddItem(Indicator, 4)
	end
end

function NormalAbilitys.Laugh(playerclassproperties)
	local player: Player = playerclassproperties.player

	local Character = player.Character
	local Hitbox = game.ReplicatedStorage.Models.FieldOfView.HitBox:Clone()
	Hitbox.Position = Character:FindFirstChild("HumanoidRootPart").Position
	Hitbox.Parent = game.Workspace
	local HittedPlayers = {}
	local RemoteEvent: RemoteEvent = ReplicatedStorage:FindFirstChild("Event"):FindFirstChild("StatusApplier")
	local SoundEvent: UnreliableRemoteEvent = ReplicatedStorage.Event.SoundPlayer.PlaySound
	SoundEvent:FireAllClients("rbxassetid://8417230527", Character:FindFirstChild("HumanoidRootPart").Position)
	for _, Part in workspace:GetPartsInPart(Hitbox) do
		print(Part)
		local Humanoid = Part.Parent:FindFirstChild("Humanoid")
		if Humanoid then
			local EnemyPlayer: Player = PlayerService:GetPlayerFromCharacter(Part.Parent)
			print(EnemyPlayer.UserId)
			if EnemyPlayer.Team ~= game.Teams.Survivor or HittedPlayers[EnemyPlayer] then
				continue
			end
			RemoteEvent:FireClient(EnemyPlayer, "FieldOfView", 10)
			HittedPlayers[EnemyPlayer] = true
		end
	end
	Hitbox:Destroy()
end
function NormalAbilitys.PorkCall()
	local function CreateHighlight(Character)
		local HiglightInstance: Highlight = Instance.new("Highlight")
		HiglightInstance.FillTransparency = 0.6
		HiglightInstance.OutlineColor = Color3.fromRGB(255, 0, 0)
		HiglightInstance.FillColor = Color3.fromRGB(255, 0, 0)
		HiglightInstance.Parent = Character
		game.Debris:AddItem(HiglightInstance, 5)
	end

	for _, EnemyPlayer: Player in SurvivorNextbotAlive.GetSurvivor() do
		if not EnemyPlayer.Character then
			continue
		end
		ReplicatedStorage.Event.ConsequenceApllier:FireClient(EnemyPlayer, "PorkCall")
		local Character = EnemyPlayer.Character
		CreateHighlight(Character)
	end
end

function NormalAbilitys.SpeedBoost(playerclassproperties)
	local player: Player = playerclassproperties.player

	print(playerclassproperties)
	local Character = player.Character
	if Character then
		local Humanoid: Humanoid = Character:FindFirstChild("Humanoid")
		Humanoid.WalkSpeed = 150
		task.delay(10, function()
			Humanoid.WalkSpeed = playerclassproperties.WalkSpeed
		end)
	end
	SoundCreator.ChangeFollowingMusic(player.UserId, "rbxassetid://139377079452785", 10)
end
function NormalAbilitys.Thunder(playerclassproperties)
	local Indicator = ReplicatedStorage.Models.Thunder.Indicator
	local ThunderEffekt = ReplicatedStorage.VFX.Thunder
	local CFrames = {}
	for _, player: Player in SurvivorNextbotAlive.GetSurvivor() do
		local IndicatorClone = Indicator:Clone()
		local ThunderEffectPart = ThunderEffekt:Clone()
		local Character = player.Character

		if not Character then
			continue
		end
		local root: Part = Character:FindFirstChild("HumanoidRootPart")
		local Raycastprop = RaycastParams.new()
		Raycastprop.CollisionGroup = "player"
		local RayCast = game.Workspace:Raycast(
			Vector3.new(root.Position.X, 200, root.Position.Z),
			Vector3.new(0, -500, 0),
			Raycastprop
		)
		IndicatorClone:PivotTo(CFrame.lookAt(root.Position, root.Position + RayCast.Normal))
		IndicatorClone.Parent = game.Workspace
		game.Debris:AddItem(IndicatorClone, 1.2)
		table.insert(CFrames, root.CFrame)
		ThunderEffectPart.Position = Vector3.new(root.Position.X, root.Position.Y + 190, root.Position.Z)
		ThunderEffectPart.Parent = game.Workspace
		task.delay(1, function()
			ThunderEffectPart.Position = Vector3.new(root.Position.X, root.Position.Y + 190, root.Position.Z)
			ThunderEffectPart.Parent = game.Workspace
			task.delay(2, function()
				ThunderEffectPart.Beam1.Enabled = false
				ThunderEffectPart.Beam2.Enabled = false
				task.delay(1, function()
					ThunderEffectPart:Destroy()
				end)
			end)
		end)
	end
	task.wait(1)
	local hittedplayers = {}
	local overlapparams = OverlapParams.new()
	local TeamMatesCharacter = {}

	for _, player in SurvivorNextbotAlive.GetNextBots() do
		local Character = player:FindFirstChild("Character")
		if Character then
			table.insert(TeamMatesCharacter, Character)
		end
	end
	table.insert(TeamMatesCharacter, game.Workspace:FindFirstChild("Map"))
	overlapparams.FilterType = Enum.RaycastFilterType.Exclude
	overlapparams.FilterDescendantsInstances = TeamMatesCharacter
	for _ = 1, 20, 1 do
		for _, position in CFrames do
			for _, part in workspace:GetPartBoundsInBox(position, Vector3.new(15, 50, 15), overlapparams) do
				local Humanoid: Humanoid = part.Parent:FindFirstChild("Humanoid")
				if Humanoid then
					local character = Humanoid.Parent
					local Enemy = PlayerService:GetPlayerFromCharacter(character)
					if table.find(hittedplayers, Enemy) or Enemy.Team == Teams.Nextbots then
						continue
					end
					table.insert(hittedplayers, Enemy)
					Humanoid.Health = 0
				end
			end
		end
		task.wait(0.1)
	end
end

return NormalAbilitys
