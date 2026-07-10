local MathForMovment = {}

function MathForMovment.isonfloor(rootpart, distance)
	local raycastparams: RaycastParams = RaycastParams.new()
	raycastparams.FilterType = Enum.RaycastFilterType.Exclude
	raycastparams.FilterDescendantsInstances = { rootpart.Parent }
	local isfloor = game.Workspace:Raycast(rootpart.Position, Vector3.new(0, -1 * distance, 0), raycastparams)
	return isfloor
end

return MathForMovment
