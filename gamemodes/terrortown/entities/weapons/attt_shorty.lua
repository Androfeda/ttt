AddCSLuaFile()

DEFINE_BASECLASS "weapon_tttbase"

SWEP.HoldType              = "shotgun"

if CLIENT then
   SWEP.PrintName          = "Super Shorty"
   SWEP.Slot               = 6

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "vgui/ttt/icon_shotgun"
   SWEP.IconLetter         = "B"
end

SWEP.Base                  = "attt_base"

SWEP.Kind                  = WEAPON_EQUIP
SWEP.EquipMenuData = {
   type = "item_weapon",
   desc = [[
Accurate short-range shotgun.

Low capacity.]]
}
SWEP.CanBuy                = { ROLE_INNOCENT }
SWEP.LimitedStock          = true

SWEP.Primary.Ammo          = "Buckshot"
SWEP.Primary.Damage        = 11
SWEP.Primary.Cone          = 0.082
SWEP.Primary.Delay         = 0.8
SWEP.Primary.ClipSize      = 4
SWEP.Primary.ClipMax       = 24
SWEP.Primary.DefaultClip   = 4
SWEP.Primary.Automatic     = true
SWEP.Primary.NumShots      = 8
SWEP.Primary.Sound         = Sound( "Weapon_M3.Single" )
SWEP.Primary.Recoil        = 7

SWEP.AutoSpawnable         = false
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_box_buckshot_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel            = "models/weapons/w_shot_m3super90.mdl"

SWEP.IronSightsPos         = Vector(-6.881, -9.214, 2.66)
SWEP.IronSightsAng         = Vector(-0.101, -0.7, -0.201)

-- Androfeda Rewrite
SWEP.AnimOverride = {
	[ACT_VM_PRIMARYATTACK] = {
		Source = ACT_VM_PRIMARYATTACK,
		Mult = 0.88,
	},
	[ACT_VM_DRAW] = {
		Source = ACT_VM_DRAW,
		Mult = 1.2,
	},
	[ACT_SHOTGUN_RELOAD_START] = {
		Source = ACT_SHOTGUN_RELOAD_START,
		ReloadingTime = 0.2,
	},
	[ACT_VM_RELOAD] = {
		Source = ACT_VM_RELOAD,
		LoadIn = 0.2,
	},
	[ACT_SHOTGUN_RELOAD_FINISH] = {
		Source = ACT_SHOTGUN_RELOAD_FINISH,
		StopSightTime = 0.6,
	},
}

SWEP.Firemodes = {
	{
		Count = 1,
		Delay = 1.1,
	}
}

SWEP.ShotgunReloading = true

SWEP.DamageNear = 12
SWEP.DamageFar = 4
SWEP.RangeNear = 4
SWEP.RangeFar = 10

SWEP.Pellets = 7

SWEP.ViewModelFOV = 60
SWEP.ActivePos = {
	Pos = Vector(-2, -6, 0.5),
	Ang = Angle(2, 2, 0),
}
SWEP.IronsightPos = {
	Pos = Vector(-7.651, -15, 3.49),
	Ang = Angle(0.1, 0, 0),
	Mag = 1.1,
}

--
-- Recoil
--
SWEP.RecoilUp							= 8 -- degrees punched
SWEP.RecoilUpDrift						= 0.5 -- how much will be smooth recoil
SWEP.RecoilUpDecay						= 30 -- how much recoil to remove per second
SWEP.RecoilSide							= 6 -- degrees punched, in either direction (-100% to 100%)
SWEP.RecoilSideDrift					= 0.5 -- how much will be smooth recoil
SWEP.RecoilSideDecay					= 10 -- how much recoil to remove per second
SWEP.RecoilFlipChance					= ( 1 / 2 ) -- chance to flip recoil direction
SWEP.RecoilADSMult						= ( 3 / 4 ) -- multiply shot recoil by this amount when ads'd

SWEP.Dispersion							= 5
SWEP.Dispersion_Move					= 2.2 -- at 200 hu/s
SWEP.Dispersion_Air						= 2.2
SWEP.Dispersion_Crouch					= ( 3 / 4 )
SWEP.Dispersion_Sights					= ( 2 / 3 )