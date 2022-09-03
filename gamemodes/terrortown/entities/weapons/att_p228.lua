AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "P628"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "vgui/ttt/icon_pistol"
   SWEP.IconLetter         = "u"
end

SWEP.Base                  = "attt_base"

SWEP.Kind                  = WEAPON_PISTOL

SWEP.Primary.Recoil        = 1.5
SWEP.Primary.Damage        = 25
SWEP.Primary.Delay         = 0.38
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 15
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 15
SWEP.Primary.ClipMax       = 60
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Sound         = Sound( "Weapon_P228.Single" )

SWEP.AutoSpawnable         = true
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_p228.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_p228.mdl"

SWEP.IronSightsPos         = Vector(-5.95, -4, 2.799)
SWEP.IronSightsAng         = Vector(0, 0, 0)

-- Androfeda Rewrite
SWEP.AnimOverride = {
	[ACT_VM_DRAW] = {
		Source = ACT_VM_DRAW,
		Mult = 1.5,
	},
	[ACT_VM_RELOAD] = {
		Source = ACT_VM_RELOAD,
		LoadIn = 1.7,
		StopSightTime = 2.2,
	},
}

SWEP.Firemodes = {
	{
		Count = 3,
		Delay = 0.08,
		PostBurstDelay = 0.3,
	}
}

SWEP.DamageNear = 16
SWEP.DamageFar = 12
SWEP.RangeNear = 12
SWEP.RangeFar = 30

SWEP.BodyDamageMults = {
	[HITGROUP_HEAD]		= 2,
	[HITGROUP_LEFTARM]	= 1,
	[HITGROUP_RIGHTARM]	= 1,
	[HITGROUP_LEFTLEG]	= 0.55,
	[HITGROUP_RIGHTLEG]	= 0.55,
	[HITGROUP_GEAR]		= 1,
}

SWEP.ViewModelFOV = 60
SWEP.ActivePos = {
	Pos = Vector(0.5, -2, -0.5),
	Ang = Angle(2, 2, 0),
}
SWEP.IronsightPos = {
	Pos = Vector(-5.95, -4, 2.9),
	Ang = Angle(0, 0, 0),
	Mag = 1.1,
}

--
-- Recoil
--
SWEP.RecoilUp							= 4 -- degrees punched
SWEP.RecoilUpDrift						= 0.5 -- how much will be smooth recoil
SWEP.RecoilUpDecay						= 30 -- how much recoil to remove per second
SWEP.RecoilSide							= 0.5 -- degrees punched, in either direction (-100% to 100%)
SWEP.RecoilSideDrift					= 0.5 -- how much will be smooth recoil
SWEP.RecoilSideDecay					= 30 -- how much recoil to remove per second
SWEP.RecoilFlipChance					= ( 1 / 3 ) -- chance to flip recoil direction
SWEP.RecoilADSMult						= ( 1 / 3 ) -- multiply shot recoil by this amount when ads'd

SWEP.Dispersion							= 1
SWEP.Dispersion_Move					= 1.1 -- at 200 hu/s
SWEP.Dispersion_Air						= 1.1
SWEP.Dispersion_Crouch					= ( 1 / 3 )
SWEP.Dispersion_Sights					= ( 1 / 3 )

SWEP.MuzzleEffect						= "muzzleflash_famas"
SWEP.QCA_Muzzle							= 1
SWEP.QCA_Case							= 2
