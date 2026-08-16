local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local SoundCreator = require(script.Parent.SoundCreator)
local module = {}

function module.OnTimeEffect(RootObject: Part, Position)
	RootObject.Position = Position
	for _, object in RootObject:GetDescendants() do
		if object:IsA("ParticleEmitter") then
			local Particle: ParticleEmitter = object
			Particle:Emit(object:GetAttribute("EmitCount") or 1)
		end
	end
	RootObject.Parent = Workspace
	task.delay(2, function()
		RootObject:Destroy()
	end)
end

function module.Explosion(Position)
	local Explosion = ReplicatedStorage.VFX:FindFirstChild("Explosion"):Clone()
	module.OnTimeEffect(Explosion, Position)
	SoundCreator.new("rbxassetid://139771888058836", Position, 1, false)
end

function module.Thunder(Position)
	local Thunder = ReplicatedStorage.VFX:FindFirstChild("Thunder"):Clone()
	Thunder.Position = Position + Vector3.new(0, 200, 0)
	Thunder.Parent = Workspace
	task.delay(2, function()
		Thunder:Destroy()
	end)
	SoundCreator.new("rbxassetid://139968319088532", Position, 1, false)
end

function module.ShockWave(Position)
	print("Ich wurde Gerufden")
	local ShockWave = ReplicatedStorage.VFX:FindFirstChild("ShockWave"):Clone()
	local Particle: ParticleEmitter = ShockWave.Attachment:FindFirstChild("ParticleEmitter")
	ShockWave.Parent = Workspace
	ShockWave.Position = Position
	local function ShockWaveEmit()
		for _ = 1, 3 do
			Particle:Emit(1)
			task.wait(0.2)
		end
		task.delay(1, function()
			ShockWave:Destroy()
		end)
	end

	task.spawn(function()
		ShockWaveEmit()
	end)
end

return module
