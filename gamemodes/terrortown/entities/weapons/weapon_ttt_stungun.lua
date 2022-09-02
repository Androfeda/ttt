AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "stungun_name"
   SWEP.Slot               = 6

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "ump_desc"
   };

   SWEP.Icon               = "vgui/ttt/icon_ump"
   SWEP.IconLetter         = "q"
end

SWEP.Base                  = "attt_base"

SWEP.Kind                  = WEAPON_EQUIP
SWEP.WeaponID              = AMMO_STUN
SWEP.CanBuy                = {ROLE_DETECTIVE}
SWEP.LimitedStock          = true
SWEP.AmmoEnt               = "item_ammo_smg1_ttt"

SWEP.Primary.Damage        = 9
SWEP.Primary.Delay         = 0.1
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 30
SWEP.Primary.ClipMax       = 60
SWEP.Primary.DefaultClip   = 30
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "smg1"
SWEP.Primary.Recoil        = 1.2
SWEP.Primary.Sound         = Sound( "Weapon_UMP45.Single" )

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel            = "models/weapons/w_smg_ump45.mdl"

SWEP.IronSightsPos         = Vector(-8.735, -10, 4.039)
SWEP.IronSightsAng         = Vector(-1.201, -0.201, -2)

SWEP.HeadshotMultiplier    = 4.5 -- brain fizz
--SWEP.DeploySpeed = 3


function SWEP:CustomCallback(att, tr, dmginfo)
	if SERVER or (CLIENT and IsFirstTimePredicted()) then
		local ent = tr.Entity
		if (!tr.HitWorld) and IsValid(ent) then
			local edata = EffectData()

			edata:SetEntity(ent)
			edata:SetMagnitude(3)
			edata:SetScale(2)

			util.Effect("TeslaHitBoxes", edata)

			if SERVER and ent:IsPlayer() then
				local eyeang = ent:EyeAngles()

				local j = 10
				eyeang.pitch = math.Clamp(eyeang.pitch + math.Rand(-j, j), -90, 90)
				eyeang.yaw = math.Clamp(eyeang.yaw + math.Rand(-j, j), -90, 90)
				ent:SetEyeAngles(eyeang)
			end
		end
	end
end

-- Androfeda Rewrite
SWEP.AnimOverride = {
	[ACT_VM_DRAW] = {
		Source = ACT_VM_DRAW,
		Mult = 1.5,
	},
	[ACT_VM_RELOAD] = {
		Source = ACT_VM_RELOAD,
		LoadIn = 1.9,
		StopSightTime = 2.8,
	},
}

SWEP.Firemodes = {
	{
		Count = math.huge,
		Delay = 0.1,
	}
}

SWEP.DamageNear = 9
SWEP.DamageFar = 8
SWEP.RangeNear = 10
SWEP.RangeFar = 30

SWEP.BodyDamageMults = {
	[HITGROUP_HEAD]		= 4.5, -- brain fizz
	[HITGROUP_LEFTARM]	= 1,
	[HITGROUP_RIGHTARM]	= 1,
	[HITGROUP_LEFTLEG]	= 0.55,
	[HITGROUP_RIGHTLEG]	= 0.55,
	[HITGROUP_GEAR]		= 1,
}

SWEP.ViewModelFOV = 60
SWEP.ActivePos = {
	Pos = Vector(-1.4, -5, 0.6),
	Ang = Angle(2, 2, 0),
}
SWEP.IronsightPos = {
	Pos = Vector(-8.735, -10, 4.039),
	Ang = Angle(-1.201, -0.201, -2),
	Mag = 1.1,
}

--
-- Recoil
--
SWEP.RecoilUp							= 1 -- degrees punched
SWEP.RecoilUpDrift						= 0.5 -- how much will be smooth recoil
SWEP.RecoilUpDecay						= 30 -- how much recoil to remove per second
SWEP.RecoilSide							= 1 -- degrees punched, in either direction (-100% to 100%)
SWEP.RecoilSideDrift					= 0.5 -- how much will be smooth recoil
SWEP.RecoilSideDecay					= 30 -- how much recoil to remove per second
SWEP.RecoilFlipChance					= ( 1 / 3 ) -- chance to flip recoil direction
SWEP.RecoilADSMult						= ( 1 / 3 ) -- multiply shot recoil by this amount when ads'd

SWEP.Dispersion							= 2
SWEP.Dispersion_Move					= 2 -- at 200 hu/s
SWEP.Dispersion_Air						= 2
SWEP.Dispersion_Crouch					= ( 1 / 3 )
SWEP.Dispersion_Sights					= ( 1 / 3 )