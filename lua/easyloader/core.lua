-- Easy Loader by PrikolMen#3372
local version = 3.0
if EasyLoader and ((EasyLoader["_VERSION"] or 0) > version) then return end

EasyLoader = {
    ["_VERSION"] = version,
    ["_COLOR"] = {
        ["Client"] = Color(255, 193, 7),
        ["Server"] = Color(40, 192, 252),
        ["Text"] = Color(250, 238, 255),
        ["Error"] = Color(202, 50, 50)
    }
}

local debug_getregistry = debug.getregistry
local string_EndsWith = string.EndsWith
local AddCSLuaFile = AddCSLuaFile
local string_lower = string.lower
local string_Left = string.Left
local file_Find = file.Find
local table_Add = table.Add
local include = include
local ipairs = ipairs
local unpack = unpack
local assert = assert
local MsgC = MsgC
local type = type

function EasyLoader:Include(fileName)
    assert(type(fileName) == "string", "bad argument #1 (string expected)")

    local errorHandler = debug_getregistry()[1]
    local lastError
    debug_getregistry()[1] = function(err)
        lastError = err
        return err
    end

    local args = { include(fileName) }
    debug_getregistry()[1] = errorHandler

    if lastError then
        self:Log(nil, "Error on including: ", self:SideColor(), fileName, "\n", self["_COLOR"]["Error"], lastError)
        return false, lastError
    else
        return true, unpack(args)
    end
end


function EasyLoader:SideColor()
	return CLIENT and self["_COLOR"]["Client"] or self["_COLOR"]["Server"]
end

function EasyLoader:Log(tag, ...)
    MsgC(self:SideColor(), "["..(tag or "EasyLoader").."] ", self["_COLOR"]["Text"], unpack(table_Add({...}, {"\n"})))
end

function EasyLoader:BuildPath(dir, fl)
	if isstring(dir) then
		if isstring(fl) then
			if not string_EndsWith(dir, "/") then
				dir = dir .. "/"
			end
		else
			return false
		end
	elseif not isstring(fl) then
		return false
	end

	return (dir or "") .. (fl or "")
end

function EasyLoader:LoadFile(dir, fl, tag)
    local fileSide = string_lower(string_Left(fl , 3))
    local path = self:BuildPath(dir, fl)

    if SERVER and (fileSide == "sv_") then
        self:Include(path)
        self:Log(tag, fl)
    elseif (fileSide == "cl_") then
        if SERVER then
            AddCSLuaFile(path)
        elseif CLIENT then
            self:Include(path)
            self:Log(tag, fl)
        end
    else
        if SERVER then
            AddCSLuaFile(path)
        end

        self:Include(path)
        self:Log(tag, fl)
    end
end

local client = {"_cl", "cl", "client", "cln", "cli", "clnt"}
local server = {"_sv", "sv", "server", "srv", "serv"}

function EasyLoader:IsRightSide(path)
    for _, str in ipairs(string.Split(path, "/")) do
        for _, srv in ipairs(server) do
            if (str:lower() == srv) then
                return SERVER
            end
        end

        for _, cl in ipairs(client) do
            if (str:lower() == cl) then
                return CLIENT
            end
        end
    end

    return true
end

function EasyLoader:Load(dir, tag)
	assert(type(dir) == "string", "bad argument #1 (string expected)")

    if (dir != "") then
        if not self:IsRightSide(dir) then
            return
        end

        if (dir:find("/") == nil) then
            self:Log(nil, "Launching: ", self:SideColor(), dir)
        end

        dir = dir .. "/"
    end

    local fls, fols = file_Find(dir .. "*", "LUA")
    for _, fl in ipairs(fls) do
        if string_EndsWith(fl, ".lua") then
            self:LoadFile(dir, fl, tag)
        end
    end

    for _, fol in ipairs(fols) do
        self:Load(dir .. fol, tag)
        self:Log(tag, fol)
    end
end

return EasyLoader