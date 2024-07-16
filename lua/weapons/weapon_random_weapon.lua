AddCSLuaFile()
SWEP.Base = "weapon_base"
SWEP.PrintName = "Random Weapon"
SWEP.Category = "Other"
SWEP.Author = "The_UltimateNuke"
SWEP.Instructions = "Turns into a random SWEP from a list of all weapons"
SWEP.HoldType = "pistol"
SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.Weight = 1000
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.Spawnable = true
SWEP.ViewModelFlip = true
SWEP.UseHands = true
SWEP.DrawCrosshair = true
hook.Add(
    "InitPostEntity",
    "nrm_get_weapons",
    function()
        weaponsList = weapons.GetList()
    end
)

function SWEP:PickRandomWeapon()
    return weaponsList[math.random(#weaponsList)]
end

function SWEP:RemoveRandomWeapons(ply)
    local curWeaponsList = ply:GetWeapons()
    for _, weapon in ipairs(curWeaponsList) do
        if weapon.Random and weapon.ClassName ~= self.ClassName then
            ply:StripWeapon(weapon.ClassName)
        end
    end
end

function SWEP:Transform()
    local ent = self:GetOwner()
    if not ent or not ent:IsValid() then return end
    local random_weapon = self:PickRandomWeapon()
    local execTimeout = 5 -- How many times the while loop can execute before giving up
    local curExec = 0
    while curExec < execTimeout and (not IsValid(random_weapon) or random_weapon.ClassName == self.ClassName or not random_weapon.Spawnable) do
        random_weapon = self:PickRandomWeapon()
        curExec = curExec + 1
    end

    random_weapon.Random = true
    self:RemoveRandomWeapons(ent)
    ent:Give(random_weapon.ClassName)
    ent:SelectWeapon(random_weapon.ClassName)
    RunConsoleCommand("givecurrentammo")
end

-- Hook into EVERY weapon interaction hook to make sure the weapon actually switches at some point
function SWEP:PrimaryAttack()
    self:Transform()
end

function SWEP:Reload()
    self:Transform()
end

function SWEP:Deploy()
    self:Transform()
end