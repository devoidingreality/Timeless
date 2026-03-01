local genv = (getgenv and getgenv()) or shared

local Settings = genv.Settings
local Module = genv.Module

local Button = Module.Button
local Asset = Module.Asset

local btn = "Button"
local pos = {0, 0}

local off = Asset.get("Timeless/" .. btn .. "_off.png")
local on = Asset.get("Timeless/" .. btn .. "_on.png")

local button, uc = Button.new(btn, pos, true); do
	button.Image = off
	button.PressedImage = on

	uc.Image = off
end

--

local function ButtonDown()
	print("Button on")
end

local function ButtonUp()
	print("Button off")
end

button.MouseButton1Down:Connect(ButtonDown)
button.MouseButton1Up:Connect(ButtonUp)
