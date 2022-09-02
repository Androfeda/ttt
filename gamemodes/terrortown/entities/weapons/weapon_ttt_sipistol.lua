AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "sipistol_name"
   SWEP.Slot               = 6

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = [[
Low-noise handgun, uses pistol ammo.

Tranquilizer mix ensures victims
will not scream when killed.]]
   };

   SWEP.Icon               = "vgui/ttt/icon_silenced"
   SWEP.IconLetter         = "a"
end

SWEP.Base                  = "attt_base"

SWEP.Primary.Recoil        = 1.35
SWEP.Primary.Damage        = 28
SWEP.Primary.Delay         = 0.38
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 20
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.ClipMax       = 60
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Sound         = Sound( "Weapon_USP.SilencedShot" )
SWEP.Primary.SoundLevel    = 50

SWEP.Kind                  = WEAPON_EQUIP
SWEP.CanBuy                = {ROLE_TRAITOR} -- only traitors can buy
SWEP.WeaponID              = AMMO_SIPISTOL
SWEP.LimitedStock          = true

SWEP.AmmoEnt               = "item_ammo_pistol_ttt"
SWEP.IsSilent              = true

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_usp_silencer.mdl"

SWEP.IronSightsPos         = Vector( -5.91, -4, 2.84 )
SWEP.IronSightsAng         = Vector(-0.5, 0, 0)

-- We were bought as special equipment, and we have an extra to give
function SWEP:WasBought(buyer)
	if IsValid(buyer) then -- probably already self:GetOwner()
		buyer:GiveAmmo( 20, "Pistol" )
	end
end

-- Androfeda Rewrite
SWEP.AnimOverride = {
	[ACT_VM_PRIMARYATTACK] = {
		Source = ACT_VM_PRIMARYATTACK_SILENCED,
	},
	[ACT_VM_RELOAD] = {
		Source = ACT_VM_RELOAD_SILENCED,
		LoadIn = 1.5,
		StopSightTime = 1.9,
	},
	[ACT_VM_DRAW] = {
		Source = ACT_VM_DRAW_SILENCED,
		Mult = 1.5,
	},
	[ACT_VM_IDLE] = {
		Source = ACT_VM_IDLE_SILENCED,
	},
}

SWEP.Firemodes = {
	{
		Count = 1,
		Delay = 0.17,
	}
}

SWEP.DamageNear = 18
SWEP.DamageFar = 17
SWEP.RangeNear = 15
SWEP.RangeFar = 25

SWEP.ViewModelFOV = 60
SWEP.ActivePos = {
	Pos = Vector(0.5, -2, -0.5),
	Ang = Angle(2, 2, 0),
}
SWEP.IronsightPos = {
	Pos = Vector( -5.91, -4, 2.71 ),
	Ang = Angle(0, 0, 0),
	Mag = 1.1,
}

--
-- Recoil
--
SWEP.RecoilUp							= 2 -- degrees punched
SWEP.RecoilUpDrift						= 1 -- how much will be smooth recoil
SWEP.RecoilUpDecay						= 30 -- how much recoil to remove per second
SWEP.RecoilSide							= 0.3 -- degrees punched, in either direction (-100% to 100%)
SWEP.RecoilSideDrift					= 0.8 -- how much will be smooth recoil
SWEP.RecoilSideDecay					= 30 -- how much recoil to remove per second
SWEP.RecoilFlipChance					= ( 1 / 3 ) -- chance to flip recoil direction
SWEP.RecoilADSMult						= ( 1 / 3 ) -- multiply shot recoil by this amount when ads'd

SWEP.Dispersion							= 1
SWEP.Dispersion_Move					= 0.7 -- at 200 hu/s
SWEP.Dispersion_Air						= 0.7
SWEP.Dispersion_Crouch					= ( 1 / 3 )
SWEP.Dispersion_Sights					= ( 1 / 3 )