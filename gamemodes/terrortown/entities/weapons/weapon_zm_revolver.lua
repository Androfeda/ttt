AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "Deagle"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "vgui/ttt/icon_deagle"
end

SWEP.Base                  = "attt_base"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_DEAGLE

SWEP.Primary.Ammo          = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil        = 6
SWEP.Primary.Damage        = 37
SWEP.Primary.Delay         = 0.6
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 8
SWEP.Primary.ClipMax       = 36
SWEP.Primary.DefaultClip   = 8
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound( "Weapon_Deagle.Single" )

SWEP.HeadshotMultiplier    = 4

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_revolver_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_deagle.mdl"

SWEP.IronSightsPos         = Vector(-6.361, -3.701, 2.15)
SWEP.IronSightsAng         = Vector(0, 0, 0)

-- Androfeda Rewrite
SWEP.AnimOverride = {
	[ACT_VM_DRAW] = {
		Source = ACT_VM_DRAW,
		Mult = 1.5,
	},
	[ACT_VM_RELOAD] = {
		Source = ACT_VM_RELOAD,
		LoadIn = 1.4,
		StopSightTime = 1.5,
	},
}

SWEP.Firemodes = {
	{
		Count = 1,
		Delay = 0.5,
	}
}

SWEP.DamageNear = 37 -- Gun of gods
SWEP.DamageFar = 37
SWEP.RangeNear = 12
SWEP.RangeFar = 30

SWEP.BodyDamageMults = {
	[HITGROUP_HEAD]		= 4,
	[HITGROUP_LEFTARM]	= 1,
	[HITGROUP_RIGHTARM]	= 1,
	[HITGROUP_LEFTLEG]	= 0.55,
	[HITGROUP_RIGHTLEG]	= 0.55,
	[HITGROUP_GEAR]		= 1,
}

SWEP.ViewModelFOV = 60
SWEP.ActivePos = {
	Pos = Vector(0.5, -3, -0.8),
	Ang = Angle(2, 2, 0),
}
SWEP.IronsightPos = {
	Pos = Vector(-6.361, -3.701, 2.15),
	Ang = Angle(0, 0, 0),
	Mag = 1.2,
}

--
-- Recoil
--
SWEP.RecoilUp							= 4 -- degrees punched
SWEP.RecoilUpDrift						= 0.5 -- how much will be smooth recoil
SWEP.RecoilUpDecay						= 20 -- how much recoil to remove per second
SWEP.RecoilSide							= 2 -- degrees punched, in either direction (-100% to 100%)
SWEP.RecoilSideDrift					= 0.5 -- how much will be smooth recoil
SWEP.RecoilSideDecay					= 10 -- how much recoil to remove per second
SWEP.RecoilFlipChance					= ( 1 / 4 ) -- chance to flip recoil direction
SWEP.RecoilADSMult						= ( 1 / 4 ) -- multiply shot recoil by this amount when ads'd

SWEP.Dispersion							= 0.5
SWEP.Dispersion_Move					= 1.2 -- at 200 hu/s
SWEP.Dispersion_Air						= 0.6
SWEP.Dispersion_Crouch					= ( 1 / 3 )
SWEP.Dispersion_Sights					= ( 1 / 5 )

SWEP.MuzzleEffect						= "muzzleflash_pistol_deagle"
SWEP.QCA_Muzzle							= 1
SWEP.QCA_Case							= 2