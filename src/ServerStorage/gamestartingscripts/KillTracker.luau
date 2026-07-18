local KillTracker = {}
local Track = false
local BoxSize = Vector3.new(10, 6, 10)
function KillTracker.StartKilling(Nextbots)
	local Overlaps: OverlapParams = OverlapParams.new()
	Track = true
	local Characters = {}
	for _, player in Nextbots do
		table.insert(Characters, player.Character)
	end
	Overlaps.FilterDescendantsInstances = Characters
	Overlaps.FilterType = Enum.RaycastFilterType.Exclude
	while Track do
		print(Characters)
		for _, character in Characters do
			local root = character:FindFirstChild("HumanoidRootPart")
			if root then
				for _, Part in workspace:GetPartBoundsInBox(root.CFrame, BoxSize, Overlaps) do
					local Humanoid: Humanoid = Part.Parent:FindFirstChild("Humanoid")
					if Humanoid then
						Humanoid.Health = 0
					end
				end
			end
		end
		task.wait(0.05)
	end
	table.clear(Characters)
	print("Ended")
end
function KillTracker.StopKilling()
	Track = false
end

return KillTracker
