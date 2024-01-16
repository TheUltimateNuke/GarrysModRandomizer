AddCSLuaFile("util.lua")

local M = include("util.lua")

DeriveGamemode("sandbox")

GM.Name = "Randomizer"
GM.Author = "The_UltimateNuke"
GM.Email = "nuke.public@gmail.com"
GM.Website = "https://github.com/TheUltimateNuke"

GM.IsSandboxDerived = true

function ChooseRandomProp()
    local random_entity
    random_entity = ents.Create("prop_physics")
    random_entity:SetModel(modelFiles[math.random(1, #modelFiles)])
    if SERVER then
        random_entity:PhysicsInit(SOLID_VPHYSICS)
    end

    return random_entity
end

function OnDeath(ply, att, infl)
    if (ply == att) then return end

    if not att:IsPlayer() then return end
    att:SelectWeapon("weapon_random_weapon")

    local random_entity = ChooseRandomProp()
    local pos = ply:GetPos()
    random_entity:Spawn()
    random_entity:SetPos(pos)
end

function GM:Initialize()
    modelFiles = M:FindFilesInRecursiveMode("models", ".mdl")
end

function GM:PlayerLoadout(pl)
    pl:Give("weapon_random_weapon")
end

function GM:PlayerDeath(ply, att, infl)
    OnDeath(ply, att, infl)
end

function GM:OnNPCKilled(ply, att, infl)
    OnDeath(ply, att, infl)
end

function GM:Tick()
    if #player.GetAll() == 0 then return end
    for _,ply in ipairs(player.GetAll()) do
        if ply:Alive() and not ply:HasWeapon("weapon_random_weapon") then ply:Give("weapon_random_weapon") end
    end
end