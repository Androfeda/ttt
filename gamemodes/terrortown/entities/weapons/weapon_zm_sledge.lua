AddCSLuaFile()

SWEP.HoldType              = "crossbow"

if CLIENT then
   SWEP.PrintName          = "H.U.G.E-249"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "vgui/ttt/icon_m249"
   SWEP.IconLetter         = "z"
end

SWEP.Base                  = "attt_base"

SWEP.Spawnable             = true
SWEP.AutoSpawnable         = true

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_M249

SWEP.Primary.Damage        = 7
SWEP.Primary.Delay         = 0.06
SWEP.Primary.Cone          = 0.09
SWEP.Primary.ClipSize      = 150
SWEP.Primary.ClipMax       = 150
SWEP.Primary.DefaultClip   = 150
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "AirboatGun"
SWEP.Primary.Recoil        = 1.9
SWEP.Primary.Sound         = Sound("Weapon_m249.Single")

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel            = "models/weapons/w_mach_m249para.mdl"

SWEP.HeadshotMultiplier    = 2.2

SWEP.IronSightsPos         = Vector(-5.96, -5.119, 2.349)
SWEP.IronSightsAng         = Vector(0, 0, 0)

-- Androfeda Rewrite
SWEP.AnimOverride = {
	[ACT_VM_DRAW] = {
		Source = ACT_VM_DRAW,
		Mult = 1.5,
	},
}

SWEP.Firemodes = {
	{
		Count = math.huge,
		Delay = 0.084,
	}
}

SWEP.DamageNear = 10
SWEP.DamageFar = 7
SWEP.RangeNear = 30
SWEP.RangeFar = 50

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
	Pos = Vector(-0.8, -3, -0.2),
	Ang = Angle(2, 2, 0),
}
SWEP.IronsightPos = {
	Pos = Vector(-5.96, -5.119, 2.349),
	Ang = Angle(0, 0, 0),
	Mag = 1.1,
}

--
-- Recoil
--
SWEP.RecoilUp							= 2.8 -- degrees punched
SWEP.RecoilUpDrift						= 0.8 -- how much will be smooth recoil
SWEP.RecoilUpDecay						= 30 -- how much recoil to remove per second
SWEP.RecoilSide							= 1 -- degrees punched, in either direction (-100% to 100%)
SWEP.RecoilSideDrift					= 1 -- how much will be smooth recoil
SWEP.RecoilSideDecay					= 30 -- how much recoil to remove per second
SWEP.RecoilFlipChance					= ( 1 / 3 ) -- chance to flip recoil direction
SWEP.RecoilADSMult						= ( 1 / 3 ) -- multiply shot recoil by this amount when ads'd

SWEP.Dispersion							= 3
SWEP.Dispersion_Move					= 1.2 -- at 200 hu/s
SWEP.Dispersion_Air						= 1.2
SWEP.Dispersion_Crouch					= ( 1 / 3 )
SWEP.Dispersion_Sights					= ( 1 / 3 )

SWEP.MuzzleEffect						= "muzzleflash_minimi"
SWEP.QCA_Muzzle							= 1
SWEP.QCA_Case							= 2

