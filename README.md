# gmod_easyloader
Easy Loader - easy way to load your addons & gamemodes

## Example (In your autorun lua file)
```lua
if not EasyLoader then
    if SERVER then
        AddCSLuaFile("easyloader/easyloader_compact.lua")
    end

    include("easyloader/easyloader_compact.lua")
end

MyAddon = MyAddon or {} -- Your addon global table (You don't have to create it and just use EasyLoader.Load("path/to/your/addon/in/lua", "YourAddonName"))
EasyLoader:Load("myaddon", "MyAddon") -- myaddon - path to yours addon lua folder (example: lua/myaddon)
MyAddon["Loaded] = true -- After load you can add to your global addon table Loaded value for checks
```
