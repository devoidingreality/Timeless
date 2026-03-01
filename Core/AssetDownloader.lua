local genv = (getgenv and getgenv()) or shared
local prefix = "[Timeless/AssetDownloader.lua]:"

local getsynasset = getsynasset or getcustomasset or function() end

genv.Module = genv.Module or {}
local Module = genv.Module
local Settings = genv.Settings

local AlwaysRedownloadAssets = Settings.AlwaysRedownloadAssets

local Asset = Module.Asset

local AssetTable = {}
AssetTable.Animations = {
	"Sprint.rbxm"
}
AssetTable.AutoLoadedEffects = {
	"crt.png",
	"hurtOverlay.png",
	"vignette.png",

	"logo.png",

	"ShiftLock_cursor.png"
}
AssetTable.Buttons = {
	"Button_off.png",
	"Button_on.png",

	"DashButton_off.png",
	"DashButton_on.png",

	"DropButton_off.png",
	"DropButton_on.png",

	"FaintButton_off.png",
	"FaintButton_on.png",

	"JumpButton_off.png",
	"JumpButton_on.png",

	"NVButton_off.png",
	"NVButton_on.png",

	"ResetButton_off.png",
	"ResetButton_on.png",

	"ShiftLockButton_off.png",
	"ShiftLockButton_on.png",

	"SitButton_off.png",
	"SitButton_on.png",

	"SprintButton_off.png",
	"SprintButton_on.png"
}
AssetTable.Sounds = {
	"Dash.wav"
}

local activeTasks = 0

for name, entry in pairs(AssetTable) do
	print(prefix, "Attempt to access", name)
	for _, v in ipairs(entry) do
		task.spawn(function()
			activeTasks += 1
			if AlwaysRedownloadAssets then 
				delfolder("Timeless")
				makefolder("Timeless")
			end
		
			Asset.write("https://raw.githubusercontent.com/devoidingreality/Timeless/refs/heads/main/Assets/"..name.."/"..v, "Timeless/" .. v)

			activeTasks -= 1
		end) 
	end
end

repeat task.wait() until activeTasks == 0

print(prefix, "Done loading assets")
