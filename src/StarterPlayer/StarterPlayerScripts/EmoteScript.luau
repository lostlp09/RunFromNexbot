local module = {}
local mouse = game.Players.LocalPlayer:GetMouse()
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ScreeGui = Player.PlayerGui:WaitForChild("Emote")
local UiGradiant: UIGradient = ScreeGui.Frame.EmoteWheel.UIGradient
local InputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Connection
local Input: InputAction = Player:WaitForChild("CustomInputs"):WaitForChild("Emote"):WaitForChild("Emote")
local TweenService = game:GetService("TweenService")
local EmotePlayer = require(ReplicatedStorage.Shared.EmotePlayer.EmotePlayer)
local ClientData = require(script.Parent.ClientData)
local RootFrame = ScreeGui.Frame
local Info = TweenInfo.new(0.05, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0)
local currentValue = 90
local WheelTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false)
local EmoteChoose = 0
local RigFolder = RootFrame:WaitForChild("ViewportFrame"):WaitForChild("Rigs")
local oldstate = false
local RequestEmote: RemoteEvent = ReplicatedStorage.Event.RequestEmote
local function WheelOnOrOFF(boolean: boolean)
	local WheelTweenProperties
	if boolean then
		WheelTweenProperties = { Size = UDim2.new(0.7, 0, 0.7, 0) }
	else
		WheelTweenProperties = { Size = UDim2.new(0, 0, 0, 0) }
	end
	local wheelTween = TweenService:Create(RootFrame, WheelTweenInfo, WheelTweenProperties)
	wheelTween:Play()
end

Input.StateChanged:Connect(function(bool: boolean)
	print(bool)
	print("ChangedState", Input:GetState())
	if bool then
		WheelOnOrOFF(true)
		for i = 1, 4, 1 do
			local key = tostring(i)
			print(ClientData.Data)
			local Emote = ClientData.Data.EmoteEquiped[key]
			if not Emote then
				continue
			end
			local Rig = RigFolder:FindFirstChild(tostring(key))
			local RigHumanoid = Rig:FindFirstChild("Humanoid")
			local RigAnimator = RigHumanoid:FindFirstChild("Animator")
			print(Emote)
			print("Dance Monkey Dance")
			EmotePlayer.Play(Emote, RigAnimator)
		end
		Connection = RunService.RenderStepped:Connect(function()
			local midpoint = Vector2.new(ScreeGui.AbsoluteSize.X / 2, ScreeGui.AbsoluteSize.Y / 2)
			local X = midpoint.X - mouse.X
			local Y = midpoint.Y - mouse.Y

			local value = (math.deg(math.atan2(Y, X)) + 360) % 360
			local roundedValue = math.round(value)
			local valueNew = math.round(roundedValue / 90) * 90
			local EmoteValue = math.round(roundedValue / 90)
			if EmoteValue == 0 then
				EmoteChoose = 4
			else
				EmoteChoose = EmoteValue
			end
			if valueNew == 360 then
				valueNew = 0
			end
			if currentValue ~= valueNew then
				local diff = valueNew - currentValue
				if diff > 180 then
					diff -= 360
				elseif diff < -180 then
					diff += 360
				end
				UiGradiant.Rotation = currentValue
				local Properties = {
					Rotation = currentValue + diff,
				}

				currentValue = valueNew

				local tween = TweenService:Create(UiGradiant, Info, Properties)
				tween:Play()
			end
		end)
	else
		if Connection then
			Connection:Disconnect()
			print("HALLO WERDE ICH GERADE GESTARTEt")
			Connection = nil
			local Emote = ClientData.Data.EmoteEquiped[tostring(EmoteChoose)]
			if Emote then
				print("Event wird Gesendet")
				RequestEmote:FireServer(Emote)
			end
			print(EmoteChoose)
			WheelOnOrOFF(false)
		end
	end
end)

return module
