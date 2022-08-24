AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "rifle_name"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "vgui/ttt/icon_scout"
   SWEP.IconLetter         = "n"
end

SWEP.Base                  = "attt_base"

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_RIFLE

SWEP.Primary.Delay         = 1.5
SWEP.Primary.Recoil        = 7
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "357"
SWEP.Primary.Damage        = 50
SWEP.Primary.Cone          = 0.005
SWEP.Primary.ClipSize      = 10
SWEP.Primary.ClipMax       = 20 -- keep mirrored to ammo
SWEP.Primary.DefaultClip   = 10
SWEP.Primary.Sound         = Sound("Weapon_Scout.Single")

SWEP.Secondary.Sound       = Sound("Default.Zoom")

SWEP.HeadshotMultiplier    = 4

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_357_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = Model("models/weapons/cstrike/c_snip_scout.mdl")
SWEP.WorldModel            = Model("models/weapons/w_snip_scout.mdl")

SWEP.IronSightsPos         = Vector( 5, -15, -2 )
SWEP.IronSightsAng         = Vector( 2.6, 1.37, 3.5 )

-- Androfeda Rewrite
SWEP.Firemodes = {
	{
		Count = math.huge,
		Delay = 1.5,
	}
}

SWEP.DamageNear = 22
SWEP.DamageFar = 24
SWEP.RangeNear = 20
SWEP.RangeFar = 50

SWEP.ViewModelFOV = 70--60
SWEP.ActivePos = {
	Pos = Vector(-0.9, -4, -0.6),
	Ang = Angle(3, 3, -5),
}
SWEP.IronsightPos = {
	Pos = Vector( -3, -15, -0 ),
	Ang = Angle( 2.6, 1.37, 3.5 ),
	Mag = 4,
}

--
-- Recoil
--
SWEP.RecoilUp							= 2.5 -- degrees punched
SWEP.RecoilUpDrift						= 0.5 -- how much will be smooth recoil
SWEP.RecoilUpDecay						= 20 -- how much recoil to remove per second
SWEP.RecoilSide							= 1.5 -- degrees punched, in either direction (-100% to 100%)
SWEP.RecoilSideDrift					= 1 -- how much will be smooth recoil
SWEP.RecoilSideDecay					= 10 -- how much recoil to remove per second
SWEP.RecoilFlipChance					= ( 1 / 3 ) -- chance to flip recoil direction
SWEP.RecoilADSMult						= ( 1 / 3 ) -- multiply shot recoil by this amount when ads'd

SWEP.Dispersion							= 0.7
SWEP.Dispersion_Move					= 1.1 -- at 200 hu/s
SWEP.Dispersion_Air						= 1.1
SWEP.Dispersion_Crouch					= ( 1 / 3 )
SWEP.Dispersion_Sights					= ( 1 / 3 )