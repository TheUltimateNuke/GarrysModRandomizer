AddCSLuaFile()

SWEP.Base         = "weapon_base"
SWEP.PrintName    = "Random Weapon"
SWEP.Category     = "Other"
SWEP.Author       = "The_UltimateNuke"
SWEP.Instructions = "Turns into a random SWEP from a list of all weapons"

SWEP.HoldType       = "ar2"
SWEP.Slot           = 1
SWEP.SlotPos        = 0
SWEP.Weight         = 5
SWEP.AutoSwitchTo   = true
SWEP.AutoSwitchFrom = false

SWEP.Spawnable      = true
SWEP.AdminSpawnable = true

SWEP.ViewModelFlip  = true
SWEP.UseHands       = false
SWEP.DrawCrosshair  = true

function SWEP:Initialize()
    weaponsList = weapons.GetList()
end

function SWEP:PickRandomWeapon()
    local selectedWeapon = weaponsList[math.random(#weaponsList)]
    return selectedWeapon
end

function SWEP:RemoveRandomWeapons(ply)
    local weaponsList = ply:GetWeapons()
    for _,weapon in ipairs(weaponsList) do
        if weapon.Random then ply:StripWeapon(weapon.ClassName) end
    end
end

function SWEP:Deploy()
    local ent = self:GetOwner()
    if not ent or not ent:IsValid() then return end

    local random_weapon = self:PickRandomWeapon()
    local execTimeout = 5 -- How many times the while loop can execute before giving up
    local curExec = 0
    while curExec < execTimeout and (not IsValid(random_weapon) or random_weapon.ClassName == self.ClassName) do random_weapon = self:PickRandomWeapon() curExec = curExec + 1 end
    random_weapon.Random = true
    self:RemoveRandomWeapons(ent)
    ent:Give(random_weapon.ClassName)
    ent:SelectWeapon(random_weapon.ClassName)
    RunConsoleCommand("givecurrentammo")
end