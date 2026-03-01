local genv = (getgenv and getgenv()) or shared

local Settings = genv.Settings
local Module = genv.Module

local playingTweens = genv.playingTweens

local Button = Module.Button
local Positioner = Module.Positioner
local Asset = Module.Asset


local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local info = TweenInfo.new(
	0.8, 
	Enum.EasingStyle.Exponential,
	Enum.EasingDirection.Out
)
local info2 = TweenInfo.new(
	0.25,
	Enum.EasingStyle.Linear
)

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Humanoid.RootPart or Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

local btn = "DashButton"
local pos = Settings.Buttons.Dash.Position

local off = Asset.get("Timeless/" .. btn .. "_off.png")
local on = Asset.get("Timeless/" .. btn .. "_on.png")

local a = "http://www.roblox.com/asset/?id=178130996"
local Animation = Instance.new("Animation"); do
	Animation.AnimationId = a
end
local dB = false
local dead = false

local flash = Instance.new("Highlight"); do
	flash.Name = "DashFlash"
	flash.Adornee = Character
	flash.FillColor = Color3.new(1, 1, 1)
	flash.FillTransparency = 1
	flash.OutlineTransparency = 1
	flash.DepthMode = Enum.HighlightDepthMode.Occluded
	flash.Parent = workspace
end

local sound = Instance.new("Sound"); do
	sound.Name = "Dash"
	sound.SoundId = Asset.get("Timeless/Dash.wav")
	sound.Parent = game:GetService("SoundService")
end

local button, uc = Button.new(btn, pos, true); do
	button.Image = off
	button.PressedImage = on

	uc.Image = off
end

local function PlayTween(tween, group)
	playingTweens[group] += 1
	tween:Play()

	local comp
	comp = tween.Completed:Connect(function()
		playingTweens[group] -= 1
		comp:Disconnect()
	end)
end

button.MouseButton1Click:Connect(function()
	if not Character or not Humanoid or not HRP or not Camera or dead then return end
	
	dB = true

	sound:Play()

	local animator
	for _, v in ipairs(Character:GetDescendants()) do
		if v:IsA("Animator") then
			animator = v
		end
	end

	local k
	if not animator then
		k = Humanoid:LoadAnimation(Animation)
	else
		k = animator:LoadAnimation(Animation)
	end
	
	k:Play(0.1)

	local bFOV = Camera.FieldOfView
	local t0 = TweenService:Create(Camera, TweenInfo.new(0), { FieldOfView = bFOV * 1.25 })
	local t1 = TweenService:Create(Camera, info, { FieldOfView = bFOV })
	PlayTween(t0, "FieldOfView")
	PlayTween(t1, "FieldOfView")
		
	local Dash = Instance.new("LinearVelocity"); do
		local attach = HRP:FindFirstChild("DashAttachment"); do
			if not attach then
				attach = Instance.new("Attachment")
				attach.Name = "DashAttachment"
				attach.Parent = HRP
			end
		end

		Dash.MaxForce = 80000
		Dash.VectorVelocity = Humanoid.MoveDirection * Vector3.new(150, 150, 150) + Vector3.new(0, 5, 0)
		Dash.Attachment0 = attach
		Dash.Parent = HRP

		Debris:AddItem(Dash, 0.25)
		local t = TweenService:Create(Dash, info2, { VectorVelocity = Vector3.new(0, 0, 0) })
		PlayTween(t, "General")
	end

	flash.FillTransparency = 0
	local t2 = TweenService:Create(flash, info, { FillTransparency = 1 })
	PlayTween(t2, "General")

	repeat task.wait() until Dash.Parent == nil

	k:Stop()

	task.wait(0.15)
	
	dB = false
end)

local RStepped
local function SetupChar(char)
	if RStepped then RStepped:Disconnect() end
	
	Character = char
	Humanoid = Character:WaitForChild("Humanoid")
	HRP = Humanoid.RootPart or Character:WaitForChild("HumanoidRootPart")

	flash.Adornee = char

	RunService.RenderStepped:Connect(function()
		dead = Humanoid.Health <= 0
			
		button.Visible = not dB and Humanoid.MoveDirection.Magnitude > 0
		uc.Visible = not button.Visible
		button.Parent.Visible = not dead
	end)
end

if Player.Character then SetupChar(Player.Character) end
Player.CharacterAdded:Connect(SetupChar)
