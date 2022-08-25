AddCSLuaFile()

SWEP.HoldType            = "ar2"

if CLIENT then
   SWEP.PrintName        = "MAC10"
   SWEP.Slot             = 2

   SWEP.ViewModelFlip    = false
   SWEP.ViewModelFOV     = 54

   SWEP.Icon             = "vgui/ttt/icon_mac"
   SWEP.IconLetter       = "l"
end

SWEP.Base                = "attt_base"

SWEP.Kind                = WEAPON_HEAVY
SWEP.WeaponID            = AMMO_MAC10

SWEP.Primary.Damage      = 12
SWEP.Primary.Delay       = 0.065
SWEP.Primary.Cone        = 0.03
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 60
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 1.15
SWEP.Primary.Sound       = Sound( "Weapon_mac10.Single" )

SWEP.AutoSpawnable       = true
SWEP.AmmoEnt             = "item_ammo_smg1_ttt"

SWEP.UseHands            = true
SWEP.ViewModel           = "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.WorldModel          = "models/weapons/w_smg_mac10.mdl"

SWEP.IronSightsPos       = Vector(-8.921, -9.528, 2.9)
SWEP.IronSightsAng       = Vector(0.699, -5.301, -7)

-- Androfeda Rewrite
SWEP.AnimOverride = {
	[ACT_VM_DRAW] = {
		Source = ACT_VM_DRAW,
		Mult = 1.5,
	},
	[ACT_VM_RELOAD] = {
		Source = ACT_VM_RELOAD,
		LoadIn = 1.8,
		StopSightTime = 2.8,
	},
}

SWEP.Firemodes = {
	{
		Count = math.huge,
		Delay = 0.076,
	}
}

SWEP.DamageNear = 11
SWEP.DamageFar = 8
SWEP.RangeNear = 10
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
	Pos = Vector(-1.4, -5, -0.9),
	Ang = Angle(3, 2, -4),
}
SWEP.IronsightPos = {
	Pos = Vector(-8.921, -9.528, 2.9),
	Ang = Angle(0.699, -5.301, -7),
	Mag = 1.1,
}

--
-- Recoil
--
SWEP.RecoilUp							= 2 -- degrees punched
SWEP.RecoilUpDrift						= 1 -- how much will be smooth recoil
SWEP.RecoilUpDecay						= 30 -- how much recoil to remove per second
SWEP.RecoilSide							= 1.5 -- degrees punched, in either direction (-100% to 100%)
SWEP.RecoilSideDrift					= 1 -- how much will be smooth recoil
SWEP.RecoilSideDecay					= 30 -- how much recoil to remove per second
SWEP.RecoilFlipChance					= ( 2 / 3 ) -- chance to flip recoil direction
SWEP.RecoilADSMult						= ( 2 / 3 ) -- multiply shot recoil by this amount when ads'd

SWEP.Dispersion							= 2
SWEP.Dispersion_Move					= 1.2 -- at 200 hu/s
SWEP.Dispersion_Air						= 2.1
SWEP.Dispersion_Crouch					= ( 3 / 4 )
SWEP.Dispersion_Sights					= ( 3 / 4 )