local M = {}
function M:FindFilesInRecursiveMode(path, fileExt, pathType)
    pathType = pathType or "GAME"
    if not path or not fileExt then return nil end
    local output = {}
    local queue = {path}
    while #queue > 0 do
        for _, directory in pairs(queue) do
            local files, directories = file.Find(directory .. "/*", pathType)
            for _, filename in pairs(files) do
                print("found " .. directory .. "/" .. filename)
                if filename:EndsWith(".mdl") then
                    table.insert(output, directory .. "/" .. filename)
                end
            end

            for _, subdirectory in pairs(directories) do
                table.insert(queue, directory .. "/" .. subdirectory)
            end

            table.RemoveByValue(queue, directory)
        end
    end

    return output
end

-- https://github.com/Facepunch/garrysmod/blob/6f9183214e69a8ca3c58b546062aac28eb9dc4e5/garrysmod/gamemodes/sandbox/gamemode/commands.lua#L944
local function ConstructVehicleEntity(model, class, vname, vtable, pos, ang)
    local Ent = ents.Create(class)
    if not IsValid(Ent) then return NULL end
    Ent:SetModel(model)
    if vtable and vtable.KeyValues then
        for k, v in pairs(VTable.KeyValues) do
            local kLower = string.lower(k)
            if kLower == "vehiclescript" or kLower == "limitview" or kLower == "vehiclelocked" or kLower == "cargovisible" or kLower == "enablegun" then
                Ent:SetKeyValue(k, v)
            end
        end
    end

    Ent:SetAngles(ang)
    Ent:SetPos(pos)
    Ent:Spawn()
    Ent:Activate()
    if Ent.SetVehicleClass and vname then
        Ent:SetVehicleClass(vname)
    end

    Ent.VehicleName = vname
    Ent.VehicleTable = vtable
    Ent.ClassOverride = class

    return Ent
end

function M:SpawnVehicle(vtable, pos, ang)
    if not IsValid(ply) or not vtable then return end
    pos = pos or Vector(0, 0, 10)
    ang = ang or AngleRand(0, 359)
    local Ent = ConstructVehicleEntity(vtable.Model, vtable.Class, vtable.Name, vtable, pos, ang)
    if not IsValid(Ent) then return end
    if vtable.Members then
        table.Merge(Ent, vehicle.Members)
    end
    return Ent
end

return M