local genv = (getgenv and getgenv()) or shared

local Settings = genv.Settings
local Module = genv.Module

local gS = UserSettings().GameSettings

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local Button = Module.Button
local Asset = Module.Asset

local btn = "ShiftLockButton"
local pos = Settings.Buttons.ShiftLock.Position

local off = Asset.get("Timeless/" .. btn .. "_off.png")
local on = Asset.get("Timeless/" .. btn .. "_on.png")
local cimg = Asset.get("Timeless/ShiftLock_cursor.png")

local button, uc = Button.new(btn, pos, true); do
	button.Image = off
	button.PressedImage = on

	uc.Image = off
end

local cGui = Instance.new("ScreenGui"); do
	cGui.Name = "CursorGui"
	cGui.IgnoreGuiInset = true
	cGui.ResetOnSpawn = false
	cGui.Parent = PlayerGui
end

local cursor = Instance.new("ImageLabel"); do
	cursor.Name = "Cursor"
	cursor.Position = UDim2.fromScale(0.5, 0.5)
	cursor.AnchorPoint = Vector2.new(0.5, 0.5)
	cursor.Size = UDim2.new(0, 20, 0, 20)
	cursor.BackgroundTransparency = 1
	cursor.ImageTransparency = 1
	cursor.Active = false
	cursor.Image = cimg
	cursor.Parent = cGui
end

--

local info = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

local lastState, currentState
local eV, dV = Vector3.new(1.5, 0, 0), Vector3.zero
local active = false
local HB, Died
local dead = false
local save = active

local Humanoid, HRP, Head
local function SetupCharacter(char)
	Humanoid = char:WaitForChild("Humanoid")
	HRP = Humanoid.RootPart or char:WaitForChild("HumanoidRootPart")
	Head = char:WaitForChild("Head")

	if HB then HB:Disconnect() end
	if Died then Died:Disconnect() end

	HB = RunService.Heartbeat:Connect(function()
		dead = Humanoid.Health <= 0
		Camera = workspace.CurrentCamera

		if not Camera or not char or not Humanoid or not HRP or not Head then return end

		local FP = Head.LocalTransparencyModifier >= 1
		currentState = (active and not FP) and "on_third" or (active and FP) and "on_first" or "off"

		if currentState == lastState then return end
		lastState = currentState

		if currentState == "on_third" then
			button.Image = on
			button.PressedImage = off

			gS.RotationType = Enum.RotationType.CameraRelative

			TweenService:Create(Humanoid, info, { CameraOffset = eV }):Play()
			TweenService:Create(cursor, info, { ImageTransparency = 0 }):Play()
		elseif currentState == "on_first" then
			button.Image = on
			button.PressedImage = off

			gS.RotationType = Enum.RotationType.CameraRelative

			TweenService:Create(Humanoid, info, { CameraOffset = dV }):Play()
			TweenService:Create(cursor, info, { ImageTransparency = 0 }):Play()
		elseif currentState == "off" then
			button.Image = off
			button.PressedImage = on

			gS.RotationType = Enum.RotationType.MovementRelative

			TweenService:Create(Humanoid, info, { CameraOffset = dV }):Play()
			TweenService:Create(cursor, info, { ImageTransparency = 1 }):Play()
		end
	end)

	Died = Humanoid.Died:Connect(function()
		save = active
		active = false
	end)

	task.wait(0.5)

	active = save
end

if Player.Character then
	SetupCharacter(Player.Character)
end

Player.CharacterAdded:Connect(SetupCharacter)

local function ButtonClick()
	active = not active
end

RunService.RenderStepped:Connect(function()
	button.Visible = not dead
end)

button.MouseButton1Click:Connect(ButtonClick)
