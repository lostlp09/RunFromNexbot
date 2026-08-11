local TweenService = game:GetService("TweenService")
local module = {}

local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0) --- Change Tween Effect so everybutton is getting an other effect

function module:LoadDescendantButtons(ParentObject)
	for _, Object in ParentObject:GetDescendants() do
		if Object:IsA("GuiButton") then
			self:LoadEffectOnButton(Object)
		end
	end
end

function module:LoadEffectOnButton(Instance: GuiButton)
	local InstanceOriginalSize: UDim2 = Instance.Size
	Instance.MouseEnter:Connect(function()
		local propertyTable = {
			Size = UDim2.fromScale(InstanceOriginalSize.X.Scale * 1.2, InstanceOriginalSize.Y.Scale * 1.2),
		}
		local Tween = TweenService:Create(Instance, tweenInfo, propertyTable)
		Tween:Play()
	end)
	Instance.MouseLeave:Connect(function()
		local propertyTable = {
			Size = UDim2.fromScale(InstanceOriginalSize.X.Scale, InstanceOriginalSize.Y.Scale),
		}
		local Tween = TweenService:Create(Instance, tweenInfo, propertyTable)
		Tween:Play()
	end)
end

return module
