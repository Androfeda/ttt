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
SWEP.AnimOverride = {
	[ACT_VM_RELOAD] = {
		Source = ACT_VM_RELOAD,
		LoadIn = 1.4,
		StopSightTime = 2.2,
	},
	[ACT_VM_PRIMARYATTACK] = {
		Source = ACT_VM_PRIMARYATTACK,
		Mult = 0.88,
	},
}

SWEP.Firemodes = {
	{
		Count = 1,
		Delay = 1.5,
	}
}

SWEP.DamageNear = 50
SWEP.DamageFar = 60
SWEP.RangeNear = 20
SWEP.RangeFar = 60

SWEP.BodyDamageMults = {
	[HITGROUP_HEAD]		= 4,
	[HITGROUP_LEFTARM]	= 1,
	[HITGROUP_RIGHTARM]	= 1,
	[HITGROUP_LEFTLEG]	= 0.55,
	[HITGROUP_RIGHTLEG]	= 0.55,
	[HITGROUP_GEAR]		= 1,
}

SWEP.ViewModelFOV = 70--60
SWEP.ActivePos = {
	Pos = Vector(-0.9, -4, -0.6),
	Ang = Angle(3, 3, -5),
}
SWEP.IronsightPos = {
	Pos = Vector( -6.7, -15, 0 ),
	Ang = Angle( 0, 0, 0 ),
	Mag = 4,
}

--
-- Recoil
--
SWEP.RecoilUp							= 3 -- degrees punched
SWEP.RecoilUpDrift						= 1 -- how much will be smooth recoil
SWEP.RecoilUpDecay						= 10 -- how much recoil to remove per second
SWEP.RecoilSide							= 2 -- degrees punched, in either direction (-100% to 100%)
SWEP.RecoilSideDrift					= 1 -- how much will be smooth recoil
SWEP.RecoilSideDecay					= 20 -- how much recoil to remove per second
SWEP.RecoilFlipChance					= ( 1 / 2 ) -- chance to flip recoil direction
SWEP.RecoilADSMult						= ( 1 / 1 ) -- multiply shot recoil by this amount when ads'd

SWEP.Dispersion							= 0.5
SWEP.Dispersion_Move					= 1 -- at 200 hu/s
SWEP.Dispersion_Air						= 1
SWEP.Dispersion_Crouch					= ( 1 / 3 )
SWEP.Dispersion_Sights					= ( 1 / 15 )

if CLIENT then
local scope = Material("sprites/scope.vtf", "smooth")--surface.GetTextureID("sprites/scope")
function SWEP:CustomDrawHUD()
	local perc1 = math.Clamp( math.TimeFraction( 0.7, 0.9, self:GetSightDelta() ), 0, 1)
	local perc2 = math.Clamp( math.TimeFraction( 0.9, 1, self:GetSightDelta() ), 0, 1)
	
	local scrW = ScrW()
	local scrH = ScrH()

	local x = scrW / 2.0
	local y = scrH / 2.0
	local scope_size = scrH

	surface.SetDrawColor( 0, 0, 0, perc1*255 )
	-- crosshair
	local gap = 80
	local length = scope_size
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )

	gap = 0
	length = 50
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )

	surface.SetDrawColor( 0, 0, 0, perc2*255 )

	-- cover edges
	local sh = scope_size / 2
	local w = (x - sh) + 2
	surface.DrawRect(0, 0, w, scope_size)
	surface.DrawRect(x + sh - 2, 0, w, scope_size)
	
	-- cover gaps on top and bottom of screen
	surface.DrawLine( 0, 0, scrW, 0 )
	surface.DrawLine( 0, scrH - 1, scrW, scrH - 1 )

	surface.SetDrawColor(255, 0, 0, 255)
	surface.DrawLine(x, y, x + 1, y + 1)

	-- scope
	surface.SetMaterial(scope)
	surface.SetDrawColor(255, 255, 255, perc2*255)

	surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)
end
end