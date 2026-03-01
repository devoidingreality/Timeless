local genv = (getgenv and getgenv()) or shared -- genv stands for Global Environment! I'm assuming you know what Global Environment means, especially if you're reverse engineering this of all things.
local Settings = genv.Settings -- This was defined in EXECUTEME.lua
local prefix = "[Timeless/Main.lua]:"

genv.TimelessVersion = "2.1 (Rewritten)"
genv.playingTweens = {
	["General"] = 0,

	["WalkSpeed"] = 0,
	["FieldOfView"] = 0
}

local sErr = prefix.. [[ ATTENTION
	Hello, it's me, hi, yes. It's me.
	For some reason, the config don't exist. Whaaat a shame.
	Are you sure you're executing the right script?
	If you execute this script without the settings, half the functions break.
	Just be a good boy/girl/enby and execute the actual script, will you?
	Listen to your mommy. Also please never let me say those words ever again.
]]
print(prefix, "Created by ███████ :3")

assert(Settings and Settings.Addons, sErr)

genv.Modulars = genv.Modulars or {} -- All scripts in /Core/Module will shove their functions into this. Basically.
local Modulars = genv.Modulars

Settings.Addons = Settings.Addons or {}
local Addons = Settings.Addons

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer -- See that heart, Anon? That's your SOUL! The culmination of your being!
local PlayerGui = Player.PlayerGui -- The stuff on your screen. :P

local TouchGui = PlayerGui:WaitForChild("TouchGui")
local TouchControlFrame = TouchGui:WaitForChild("TouchControlFrame")
local JumpButton = TouchControlFrame:WaitForChild("JumpButton") -- The JumpButton! You'll see how it's used later in this script.

if TouchControlFrame:FindFirstChild("JumpButtonReference") then TouchControlFrame.JumpButtonReference:Destroy() end
local JumpRef = Instance.new("Frame", TouchControlFrame); do -- This will make a reference of the JumpButton. This is where all the buttons will show up if you have any.
	JumpRef.Name = "JumpButtonReference"
	JumpRef.BackgroundTransparency = 1
	JumpRef.Position = JumpButton.Position
	JumpRef.Size = JumpButton.Size
end

local lPos, lSize = JumpButton.Position, JumpButton.Size
local function updateGui()
	local nPos, nSize = JumpButton.Position, JumpButton.Size

	if nPos ~= lPos or nSize ~= lSize then
		JumpRef.Position = nPos
		JumpRef.Size = nSize

		lPos, lSize = nPos, nSize
	end
end

JumpButton:GetPropertyChangedSignal("Position"):Connect(updateGui)
JumpButton:GetPropertyChangedSignal("Size"):Connect(updateGui)

--|| EasyLoadstrings! ||--

-- This is a Module that will let you simply provide the file path to execute from a URL. It's better loadstring, basically.

loadstring(game:HttpGet("https://raw.githubusercontent.com/devoidingreality/Timeless/refs/heads/main/Core/Modulars/EasyLoadstrings.lua"))()
local EL = Modulars.EasyLoadstrings

--|| MODULES ||--

local modulars = {
	"Asset",
	"Button"
}

for _, name in ipairs(modulars) do
	EL.include("Core/Modulars/" .. name .. ".lua")
end

--|| ASSETS ||--

EL.include("Core/AssetDownloader.lua")
-- This should grab all the assets and download it to your workspace folder.
-- Includes images, sounds, music, and atlases.

--|| BUTTONS ||--

local b = {
	"Dash",
	"Faint",
	"Reset",
	"Sit",
	"ShiftLock",
	"Sprint"
}
local bSettings = Settings.Buttons

for _, name in ipairs(b) do
	if bSettings[name] and bSettings[name].Enabled then
		task.spawn(function()
			EL.include("Buttons/"..name..".lua")
		end)
	end
end

--|| ADDONS ||--

local a = {
	"FakeR6",
	"LimbsInFirstPerson"
}

for _, name in ipairs(a) do
	if Addons[name] and Addons[name].Enabled then
		task.defer(function()
			EL.include("Addons/"..name..".lua")
		end)
	end
end
