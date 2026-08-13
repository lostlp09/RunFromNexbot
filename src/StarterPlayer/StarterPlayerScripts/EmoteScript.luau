local module = {}
local mouse = game.Players.LocalPlayer:GetMouse()
local ClientData = require(script.Parent.ClientData)
local FileManagerService = game:GetService("FileManagerService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ScreeGui = Player.PlayerGui:WaitForChild("Emote")
local UiGradiant: UIGradient = ScreeGui.Frame.EmoteWheel.UIGradient
local InputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Teams = game:GetService("Teams")
local Connection
local Input = Player:WaitForChild("CustomInputs"):WaitForChild("Emote"):WaitForChild("Emote")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local EmotePlayer = require(ReplicatedStorage.Shared.EmotePlayer.EmotePlayer)
local MakeJumpButtonVisible = require(script.Parent.MakeJumpButtonVisible)
local RootFrame = ScreeGui.Frame
local Info = TweenInfo.new(0.05, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0)
local currentValue = 90
local WheelTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false)
local EmoteChoose = 0
local RigFolder = RootFrame:WaitForChild("ViewportFrame"):WaitForChild("Rigs")
local ControllerInput: InputAction = Input.Parent:FindFirstChild("EmoteWheel")
local EquipOrMobile = RootFrame.EquipOrMobile
local RequestEmote: RemoteEvent = ReplicatedStorage.Event.RequestEmote
local Equiping = false
local Camera: Camera = Workspace.CurrentCamera
print("EmoteScript ClientData:", ClientData, tostring(ClientData):match("0x%x+"))
function module.WheelOnOrOFF(boolean: boolean)
	print("Wheeeeel")
	if Player.Team == Teams.Nextbots then
		if Connection then
			Connection:Disconnect()
		end
	end
	local WheelTweenProperties
	if boolean then
		for i = 1, 4 do
			local key = tostring(i)
			print(key)
			print(ClientData.Data)
			local Emote = ClientData.Data.EmoteEquiped[key]
			print(ClientData.Data.EmoteEquiped)
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
		WheelTweenProperties = { Size = UDim2.fromScale(0.7, 0.7) }
	else
		WheelTweenProperties = { Size = UDim2.fromScale(0, 0) }
	end

	local wheelTween = TweenService:Create(RootFrame, WheelTweenInfo, WheelTweenProperties)
	wheelTween:Play()
end
function module.StartEmoteOnMobile()
	print(ClientData.Data)
	--local size: UDim2 = RootFrame.Size
	--if size.X.Scale > 0.1 then
	--print("die größe ist zu groß")
	--return
	--end
	UiGradiant.Enabled = false
	module.WheelOnOrOFF(true)
	local Connections = {}
	EquipOrMobile.Visible = true
	local function DisableConnections()
		for _, Connection1 in Connections do
			if Connection1 then
				Connection1:Disconnect()
			end
		end
	end
	for _, Button: GuiButton in EquipOrMobile:GetChildren() do
		if Button.Name == "Cancel" then
			local Con
			Con = Button.Activated:Connect(function()
				EquipOrMobile.Visible = false

				DisableConnections()
				module.WheelOnOrOFF(false)
			end)
			table.insert(Connections, Con)
		else
			local Con
			Con = Button.Activated:Connect(function()
				EquipOrMobile.Visible = false
				local Index = Button.Name
				print(Index)
				print(ClientData.Data.EmoteEquiped)
				local Key = ClientData.Data.EmoteEquiped[Index]
				RequestEmote:FireServer(Key)
				DisableConnections()
				module.WheelOnOrOFF(false)
			end)
			table.insert(Connections, Con)
		end
	end
end
local function ControllerPcActivateEmote(X, Y)
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
end
function module.activate()
	print("EmoteScriptAktiviert")
	Input.StateChanged:Connect(function(bool: boolean)
		local CameraCFrame = Camera.CFrame
		if bool then
			if Player.Team == Teams.Nextbots then
				return
			end
			if not Player.Character or not Player.Character:FindFirstChild("Humanoid") then
				return
			end

			UiGradiant.Enabled = true
			if Equiping or Player.PlayerGui.ShopUi.Enabled == true or Player.PlayerGui.inventory.Enabled then
				return
			end
			for i = 1, 4, 1 do
				local key = tostring(i)

				local Emote = ClientData.Data.EmoteEquiped[key]
				if not Emote then
					continue
				end
				local Rig = RigFolder:FindFirstChild(tostring(key))
				local RigHumanoid = Rig:FindFirstChild("Humanoid")
				local RigAnimator = RigHumanoid:FindFirstChild("Animator")
				EmotePlayer.Play(Emote, RigAnimator)
			end
			Camera.CameraType = Enum.CameraType.Scriptable

			if Equiping or Player.PlayerGui.ShopUi.Enabled == true or Player.PlayerGui.inventory.Enabled then
				return
			end
			if MakeJumpButtonVisible.isOnController() then
				Connection = RunService.RenderStepped:Connect(function()
					UiGradiant.Enabled = true
					if not Player.Character or not Player.Character:FindFirstChild("Humanoid") then
						Camera.CameraType = Enum.CameraType.Custom
						Connection:Disconnect()
					end
					if Player.Character:FindFirstChild("Humanoid").Health == 0 then
						Camera.CameraType = Enum.CameraType.Custom
						Connection:Disconnect()
					end

					Camera.CFrame = CameraCFrame
					local Vector2 = ControllerInput:GetState()
					ControllerPcActivateEmote(Vector2.X * -1, Vector2.Y)
				end)
			else
				Connection = RunService.RenderStepped:Connect(function()
					if not Player.Character or not Player.Character:FindFirstChild("Humanoid") then
						Camera.CameraType = Enum.CameraType.Custom
						Connection:Disconnect()
						return
					end
					if Player.Character:FindFirstChild("Humanoid").Health == 0 then
						Camera.CameraType = Enum.CameraType.Custom
						Connection:Disconnect()
						return
					end
					UiGradiant.Enabled = true
					Camera.CFrame = CameraCFrame
					local midpoint = Vector2.new(ScreeGui.AbsoluteSize.X / 2, ScreeGui.AbsoluteSize.Y / 2)
					local X = midpoint.X - mouse.X
					local Y = midpoint.Y - mouse.Y
					ControllerPcActivateEmote(X, Y)
				end)

				print("yo")
			end

			module.WheelOnOrOFF(true)
		else
			print("Bring me home")
			Camera.CameraType = Enum.CameraType.Custom
			if Connection then
				if Player.Team == Teams.Nextbots then
					return
				end
				Connection:Disconnect()

				Connection = nil
				local Emote = ClientData.Data.EmoteEquiped[tostring(EmoteChoose)]
				if Emote and Player.Character then
					RequestEmote:FireServer(Emote)
				end
				module.WheelOnOrOFF(false)
			end
		end
	end)
end

function module.ChangeEmote(key)
	print("howdy")
	UiGradiant.Enabled = false
	Equiping = true
	module.WheelOnOrOFF(true)
	local Connections = {}
	EquipOrMobile.Visible = true
	local function DisableConnections()
		for _, Connection1 in Connections do
			if Connection1 then
				Connection1:Disconnect()
			end
		end
	end
	for _, Button: GuiButton in EquipOrMobile:GetChildren() do
		if Button.Name == "Cancel" then
			local Con
			Con = Button.Activated:Connect(function()
				EquipOrMobile.Visible = false
				Equiping = false

				DisableConnections()
				Player.PlayerGui.inventory.Enabled = true
				module.WheelOnOrOFF(false)
			end)
			table.insert(Connections, Con)
		else
			local Con
			Con = Button.Activated:Connect(function()
				EquipOrMobile.Visible = false
				local Index = Button.Name
				Equiping = false
				ClientData.Data.EmoteEquiped[Index] = key
				print(Button.Name, ClientData.Data.EmoteEquiped)
				DisableConnections()
				Player.PlayerGui.inventory.Enabled = true
				module.WheelOnOrOFF(false)
			end)
			table.insert(Connections, Con)
		end
	end
end

return module
