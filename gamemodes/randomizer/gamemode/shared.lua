AddCSLuaFile("util.lua")
local Utils = include("util.lua")
DeriveGamemode("sandbox")
GM.Name = "Randomizer"
GM.Author = "The_UltimateNuke"
GM.Email = "nuke.public@gmail.com"
GM.Website = "https://github.com/TheUltimateNuke"
GM.IsSandboxDerived = true
GM.ConVars = {
    RANDOM_PROP_ON_KILL = GetConVar("nrm_randomproponkill"),
    RANDOM_WEAPON_ON_KILL = GetConVar("nrm_randomweapononkill"),
    RANDOM_GRAVITY = GetConVar("nrm_randomgravity"),
    RANDOM_GRAVITY_CHANCE = GetConVar("nrm_randomgravitychance")
}

GM.TimerEvents = {
    function(gm)
        local allPly = player.GetAll()
        local ply = allPly[math.random(1, #allPly)]
        local vehiclesList = list.Get("Vehicles")
        local vehicleNames = table.GetKeys(vehiclesList)
        local chosenVehicle = vehicleNames[math.random(#vehicleNames)]
        ply:ConCommand("gm_spawnvehicle " .. chosenVehicle)
    end,
    function(gm)
        local allPly = player.GetAll()
        for _, ply in ipairs(allPly) do
            ply:SetGravity(math.random(0.1, 1))
        end
    end,
    function(gm)
        local allPly = player.GetAll()
        local ply = allPly[math.random(1, #allPly)]
        ply:SetNWFloat("desired_size", math.random(5, 1000))
    end,
    function(gm)
        local allPly = player.GetAll()
        local ply = allPly[math.random(1, #allPly)]
        gm:SpawnRandomProp(ply:GetPos())
    end
}

hook.Add(
    "InitPostEntity",
    "nrm_timer_transmit_hook",
    function()
        if SERVER then
            timer.Create(
                "nrm_event_timer",
                60,
                math.huge,
                function()
                    hook.Run("NRM_EventTimerFinishedEvent")
                end
            )
        end

        if CLIENT then
            timer.Create(
                "nrm_keep_rweapon_check",
                0.05,
                -1,
                function(arguments)
                    if not GM.ConVars.RANDOM_WEAPON_ON_KILL:GetBool() then return end
                    if #player.GetAll() == 0 then return end
                    for _, ply in ipairs(player.GetAll()) do
                        if ply:Alive() and not ply:HasWeapon("weapon_random_weapon") then
                            ply:Give("weapon_random_weapon")
                        end
                    end
                end
            )
        end
    end
)

local prevTimeLeft = 60
hook.Add(
    "Tick",
    "nrm_timer_tick",
    function()
        if not SERVER then return end
        net.Start("nrm_timer")
        local timeLeft = timer.TimeLeft("nrm_event_timer")
        if timeLeft ~= prevTimeLeft and timeLeft ~= nil then
            net.WriteFloat(timeLeft)
            net.Broadcast()
        end

        prevTimeLeft = timeLeft
    end
)

function GM:NRM_EventTimerFinishedEvent()
    self.TimerEvents[math.random(1, #self.TimerEvents)](self)
end

function GM:Initialize()
    modelFiles = Utils:FindFilesInRecursiveMode("models", ".mdl")
end

function GM:ChooseRandomProp()
    local random_entity
    random_entity = ents.Create("prop_physics")
    random_entity:SetModel(modelFiles[math.random(1, #modelFiles)])
    if SERVER then
        random_entity:PhysicsInit(SOLID_VPHYSICS)
    end

    return random_entity
end

function GM:SpawnRandomProp(pos)
    local random_entity = self:ChooseRandomProp()
    random_entity:Spawn()
    random_entity:SetPos(pos)
end

function GM:PlayerDeath(vic, att, infl)
    self:OnDeath(vic, att, infl)
end

function GM:OnNPCKilled(vic, att, infl)
    self:OnDeath(vic, att, infl)
end

function GM:OnDeath(vic, att, infl)
    if vic == att then return end
    if not att:IsPlayer() then return end
    if self.ConVars.RANDOM_WEAPON_ON_KILL:GetBool() then
        self:SwitchToRandomWeapon(att)
    end

    if not self.ConVars.RANDOM_PROP_ON_KILL:GetBool() then
        self:SpawnRandomProp(vic:GetPos())
    end
end

function GM:SwitchToRandomWeapon(ply)
    if not ply:HasWeapon("weapon_random_weapon") then
        ply:Give("weapon_random_weapon")
    end

    ply:SelectWeapon("weapon_random_weapon")
end

function GM:PlayerLoadout(pl)
    self:SwitchToRandomWeapon(pl)
end