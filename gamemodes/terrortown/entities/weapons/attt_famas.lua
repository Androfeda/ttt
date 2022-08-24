AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "FAMAS"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 64

   SWEP.Icon               = "vgui/ttt/icon_m16"
   SWEP.IconLetter         = "w"
end

SWEP.Base                  = "attt_base"

SWEP.Kind                  = WEAPON_HEAVY

SWEP.Primary.Delay         = 0.19
SWEP.Primary.Recoil        = 1.6
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Damage        = 23
SWEP.Primary.Cone          = 0.018
SWEP.Primary.ClipSize      = 20
SWEP.Primary.ClipMax       = 60
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.Sound         = Sound( "Weapon_FAMAS.Single" )

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel            = "models/weapons/w_rif_famas.mdl"

SWEP.IronSightsPos         = Vector(-7.58, -9.2, 0.55)
SWEP.IronSightsAng         = Vector(2.599, -1.3, -3.6)

-- Androfeda Rewrite
SWEP.Firemodes = {
	{
		Count = 3,
		Delay = 0.07,
		PostBurstDelay = 0.2,
		Runoff = true, -- doesn't work yet
	}
}

SWEP.DamageNear = 23
SWEP.DamageFar = 20
SWEP.RangeNear = 20
SWEP.RangeFar = 50

SWEP.ViewModelFOV = 60
SWEP.ActivePos = {
	Pos = Vector(0.2, -2, -0.6),
	Ang = Angle(3, 4, 0),
}
SWEP.IronsightPos = {
	Pos = Vector(-6.22, -9.2, 1.1),
	Ang = Angle(0, 0, -1),
	Mag = 1.1,
}

--
-- Recoil
--
SWEP.RecoilUp							= 1 -- degrees punched
SWEP.RecoilUpDrift						= 0.2 -- how much will be smooth recoil
SWEP.RecoilUpDecay						= 10 -- how much recoil to remove per second
SWEP.RecoilSide							= 1 -- degrees punched, in either direction (-100% to 100%)
SWEP.RecoilSideDrift					= 0.5 -- how much will be smooth recoil
SWEP.RecoilSideDecay					= 10 -- how much recoil to remove per second
SWEP.RecoilFlipChance					= ( 1 / 2 ) -- chance to flip recoil direction
SWEP.RecoilADSMult						= ( 1 / 3 ) -- multiply shot recoil by this amount when ads'd

SWEP.Dispersion							= 1
SWEP.Dispersion_Move					= 3 -- at 200 hu/s
SWEP.Dispersion_Air						= 3
SWEP.Dispersion_Crouch					= ( 2 / 3 )
SWEP.Dispersion_Sights					= ( 2 / 3 )