AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "Glock"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "vgui/ttt/icon_glock"
   SWEP.IconLetter         = "c"
end

SWEP.Base                  = "attt_base"

SWEP.Primary.Recoil        = 0.9
SWEP.Primary.Damage        = 12
SWEP.Primary.Delay         = 0.10
SWEP.Primary.Cone          = 0.028
SWEP.Primary.ClipSize      = 20
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.ClipMax       = 60
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Sound         = Sound( "Weapon_Glock.Single" )

SWEP.AutoSpawnable         = true

SWEP.AmmoEnt               = "item_ammo_pistol_ttt"
SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_GLOCK

SWEP.HeadshotMultiplier    = 1.75

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_glock18.mdl"

SWEP.IronSightsPos         = Vector( -5.79, -3.9982, 2.8289 )

-- Androfeda Rewrite
SWEP.AnimOverride = {
	[ACT_VM_DRAW] = {
		Source = ACT_VM_DRAW,
		Mult = 1.5,
	},
	[ACT_VM_RELOAD] = {
		Source = ACT_VM_RELOAD,
		LoadIn = 1.4,
		StopSightTime = 1.6,
	},
}

SWEP.Firemodes = {
	{
		Count = math.huge,
		Delay = 0.08,
	}
}

SWEP.DamageNear = 12
SWEP.DamageFar = 10
SWEP.RangeNear = 12
SWEP.RangeFar = 30

SWEP.BodyDamageMults = {
	[HITGROUP_HEAD]		= 1.75,
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
	Pos = Vector( -5.79, -3.9982, 2.8289 ),
	Ang = Angle(0, 0, 0),
	Mag = 1.1,
}

--
-- Recoil
--
SWEP.RecoilUp							= 2 -- degrees punched
SWEP.RecoilUpDrift						= 1 -- how much will be smooth recoil
SWEP.RecoilUpDecay						= 40 -- how much recoil to remove per second
SWEP.RecoilSide							= 1 -- degrees punched, in either direction (-100% to 100%)
SWEP.RecoilSideDrift					= 0.5 -- how much will be smooth recoil
SWEP.RecoilSideDecay					= 40 -- how much recoil to remove per second
SWEP.RecoilFlipChance					= ( 1 / 3 ) -- chance to flip recoil direction
SWEP.RecoilADSMult						= ( 1 / 3 ) -- multiply shot recoil by this amount when ads'd

SWEP.Dispersion							= 1
SWEP.Dispersion_Move					= 1.1 -- at 200 hu/s
SWEP.Dispersion_Air						= 1.1
SWEP.Dispersion_Crouch					= ( 1 / 3 )
SWEP.Dispersion_Sights					= ( 1 / 3 )

SWEP.MuzzleEffect						= "muzzleflash_mp5"
SWEP.QCA_Muzzle							= 1
SWEP.QCA_Case							= 2
