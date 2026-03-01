local genv = (getgenv and getgenv()) or shared
local prefix = "[Timeless/EasyLoadstrings.lua]:"

genv.Modulars = genv.Modulars or {}
local Modulars = genv.Modulars

Modulars.EasyLoadstrings = Modulars.EasyLoadstrings or {}
local EL = Modulars.EasyLoadstrings

local dry = "https://raw.githubusercontent.com/devoidingreality/Timeless/refs/heads/main/"
local loaded = {}

function EL.include(path)
	local url = dry..path
	local got = game:HttpGet(url.."?nocache="..os.time())

	if loaded[url] and loaded[url] == got then return end
	loaded[url] = got

	local ok, result = pcall(function()
		return loadstring(got)() -- Make sure Roblox client doesn't cache the URL (No need to restart the game anymore)
	end)

	if not ok then
		warn((prefix .. " Failed to load '%s'\n  ¬ Error: %s"):format(path, result)) -- If the URL fails to load and/or errors outside of a connection, it will warn() this
	end
end
