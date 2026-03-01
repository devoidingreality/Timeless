local genv = (getgenv and getgenv()) or shared
local prefix = "[Timeless/Asset.lua]:"

genv.Module = genv.Module or {}
local Module = genv.Module

Module.Asset = Module.Asset or {}
local Asset = Module.Asset

local getsynasset = getsynasset or getcustomasset or function() end 
local request = syn and syn.request or http and http.request or request or function() end
local isfile = isfile or readfile and function(filename) local succ,a = pcall(function() local b = readfile(filename) end) return succ end or function() end
local readfile = readfile or function() end
local writefile = writefile or function() end
local delfile = delfile or function() end
local makefolder = makefolder or function() end
local isfolder = isfolder or function() end
local delfolder = delfolder or function() end

local works = getsynasset and request and writefile and isfile and delfile and makefolder and isfolder and delfolder

if works then
	if not isfolder("Timeless") then
		makefolder("Timeless")
		print(prefix, "Successfully created workspace/Timeless folder")
	else
		warn(prefix, "workspace/Timeless folder already exists")
	end
end
	
--|| Functions ||--

function Asset.write(url, path)
	if works then
		print(prefix, "Attempt to download asset", path)
		local Response, TempFile = request({Url = url, Method = 'GET'})
		if Response.StatusCode == 200 then
			if isfile(path) then
				if readfile(path) ~= Response.Body then
					delfile(path)
					writefile(path, Response.Body)
					print(prefix, "Successfully overwrote", path)
				else
					warn(prefix, "No difference between", path, "and", url)
				end
			else
				writefile(path, Response.Body)
				print(prefix, "Successfully downloaded", path)
			end
		else
			warn(prefix, "Failed to fetch", path, "\n URL:", url, "\n  ¬ Status Code:", Response.StatusCode, "\n  ¬ Status Message:", Response.StatusMessage)
		end
	end
end

function Asset.del(path)
	if works then
		if isfile(path) then
			delfile(path)
		else
			warn(prefix, path, "is not a valid member of workspace/Timeless")
		end
	end
end

function Asset.get(path)
	if works then
		if isfile(path) then
			local a = getsynasset(path)
			
			print(prefix, "Successfully got ID of", path, "\n  ¬", a)
			return getsynasset(path)
		else
			warn(prefix, path, "is not a valid member of workspace/Timeless")
			return
		end
	end
end
