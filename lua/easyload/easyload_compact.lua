if EasyLoader then return end
EasyLoader = {}

// Gmod Libs Preload
local AddCSLuaFile = AddCSLuaFile
local MsgC = MsgC
local string_lower = string.lower
local string_Left = string.Left
local include = include
local file_Find = file.Find
local ipairs = ipairs
local string_EndsWith = string.EndsWith
//

/*
    Easy Lua Loader Compact by PrikolMen#3372
*/

local function Log(tag, fl)
    MsgC(Color(40, 192, 252), "["..(tag or "ESL").."] ", Color(255, 194, 61), tag and (fl..": OK") or ("SV INCLUDE: "..fl), "\n")
end

function EasyLoader.Include(fl, dir, tag)
    local fileSide = string_lower(string_Left(fl , 3))

    if SERVER and fileSide == "sv_" then
        include(dir..fl)
        Log(tag, fl)
    elseif fileSide == "sh_" then
        if SERVER then 
            AddCSLuaFile(dir..fl)
            Log(tag, fl)
        end
        include(dir..fl)
        Log(tag, fl)
    elseif fileSide == "cl_" then
        if SERVER then 
            AddCSLuaFile(dir..fl)
            Log(tag, fl)
        elseif CLIENT then
            include(dir..fl)
            Log(tag, fl)
        end
    end
end

function EasyLoader.Load(dir, tag)
    dir = dir .. "/"
    local fl, folder = file_Find(dir.."*", "LUA")

    for k, v in ipairs(fl) do
        if string_EndsWith(v, ".lua") then
            EasyLoader.Include(v, dir, tag)
        end
    end
    
    for k, v in ipairs(folder) do
        EasyLoader.Load(dir..v, tag)
        Log(tag, v)
    end
end
