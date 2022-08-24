
AddCSLuaFile()

-- Better hope you don't end up in Sandbox
SWEP.Base								= "weapon_base" -- bastard of it all
SWEP.IsGrenade							= false
SWEP.Category							= "TTT"
SWEP.Spawnable							= false
SWEP.DrawCrosshair						= true
SWEP.CSMuzzleFlashes					= false	-- eek, remove this

if CLIENT then
	-- I'm assuming you know how this works already.
	SWEP.EquipMenuData = nil
	SWEP.Icon = "vgui/ttt/icon_nades"
end

SWEP.AutoSpawnable						= false	-- Spawns on the map automatically. SWEP.Kind must not be WEAPON_EQUIP
SWEP.AllowDrop							= true	-- Allow pressing Q to drop
SWEP.IsSilent							= false	-- Should victims scream on death
SWEP.Kind								= WEAPON_NONE
SWEP.CanBuy								= nil

--
-- Weapon configuration
--
SWEP.PrintName							= "TTT Androfeda base"
SWEP.Slot								= 2

SWEP.UseHands							= true
SWEP.ViewModel							= "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel							= "models/weapons/w_rif_famas.mdl"
SWEP.ViewModelFOV						= 75

SWEP.Primary.ClipSize					= -1
SWEP.Primary.DefaultClip				= 0
SWEP.Primary.Ammo						= "none"
SWEP.Primary.ClipMax					= -1

SWEP.HoldTypeHip						= "ar2"
SWEP.HoldTypeSight						= "rpg"
SWEP.HoldTypeSprint						= "passive"

--
-- Recoil
--
SWEP.RecoilUp							= 2 -- degrees punched
SWEP.RecoilUpDrift						= 0.5 -- how much will be smooth recoil
SWEP.RecoilUpDecay						= 30 -- how much recoil to remove per second
SWEP.RecoilSide							= 0.5 -- degrees punched, in either direction (-100% to 100%)
SWEP.RecoilSideDrift					= 0.5 -- how much will be smooth recoil
SWEP.RecoilSideDecay					= 30 -- how much recoil to remove per second
SWEP.RecoilFlipChance					= ( 1 / 3 ) -- chance to flip recoil direction
SWEP.RecoilADSMult						= ( 1 / 3 ) -- multiply shot recoil by this amount when ads'd

SWEP.Dispersion							= 1
SWEP.Dispersion_Move					= 2 -- at 200 hu/s
SWEP.Dispersion_Air						= 2
SWEP.Dispersion_Crouch					= ( 1 / 3 )
SWEP.Dispersion_Sights					= ( 1 / 3 )

SWEP.BodyDamageMults = {
	[HITGROUP_HEAD]		= 2.7,
	[HITGROUP_LEFTARM]	= 1,
	[HITGROUP_RIGHTARM]	= 1,
	[HITGROUP_LEFTLEG]	= 0.55,
	[HITGROUP_RIGHTLEG]	= 0.55,
	[HITGROUP_GEAR]		= 1,
}

--
-- Useless shit that you should NEVER touch
--
SWEP.Weight								= 5
SWEP.AutoSwitchTo						= false
SWEP.AutoSwitchFrom						= false
SWEP.m_WeaponDeploySpeed				= 10
-- Don't touch this
SWEP.UseHands							= false
SWEP.Primary.Automatic					= true -- This should ALWAYS be true.
SWEP.Secondary.ClipSize					= -1
SWEP.Secondary.DefaultClip				= 0
SWEP.Secondary.Automatic				= true
SWEP.Secondary.Ammo						= "none"
SWEP.Secondary.ClipMax					= -1

function SWEP:Initalize()
	self.Primary.Automatic = true
	self.Secondary.Automatic = true
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "FiredLastShot")
	self:NetworkVar("Bool", 1, "UserSight")
	self:NetworkVar("Bool", 2, "RecoilFlip")
	self:NetworkVar("Bool", 3, "FiremodeDebounce")

	self:NetworkVar("Int", 0, "BurstCount")
	self:NetworkVar("Int", 1, "Firemode")

	self:NetworkVar("Float", 0, "IdleIn")
	self:NetworkVar("Float", 1, "SightDelta")
	self:NetworkVar("Float", 2, "LoadIn")
	self:NetworkVar("Float", 3, "NextMechFire")
	self:NetworkVar("Float", 4, "ReloadingTime")
	self:NetworkVar("Float", 5, "RecoilP")
	self:NetworkVar("Float", 6, "RecoilY")

	self:NetworkVar("Float", 7, "DISP_Air")
	self:NetworkVar("Float", 8, "DISP_Move")
	self:NetworkVar("Float", 9, "DISP_Crouch")

	self:NetworkVar("Float", 10, "StopSightTime")
	
	self:SetFiremode(1)
	self:SetNextMechFire(0)
	self:SetRecoilFlip( util.SharedRandom( "recoilflipinit", 0, 1, CurTime() ) < 0.5 and true or false )
end

-- Firemodes
local unavailable = {
	Count = 1,
	Delay = 0.2,
	PostBurstDelay = 0,
}
function SWEP:GetFiremodeTable(cust)
	if !cust and self:Clip1() == 0 then
		return unavailable
	end

	return self.Firemodes[cust or self:GetFiremode()] or unavailable
end

function SWEP:SwitchFiremode(prev)
	-- lol?
	local nextfm = self:GetFiremode() + 1
	if #self.Firemodes < nextfm then
		nextfm = 1
	end
	self:GetOwner():ChatPrint("Selected " .. self:GetFiremodeName(nextfm))
	self:SetFiremode(nextfm)
end

-- Globally define the best number
HUToM = 0.0254

--
-- Firing function
--
function SWEP:PrimaryAttack()
	local ammototake = 1

	if self:GetNextPrimaryFire() > CurTime() then
		return false
	end

	if self:GetNextMechFire() > CurTime() then
		return false
	end

	if self:GetReloadingTime() > CurTime() then
		return false
	end

	if self:GetFiredLastShot() then
		return false
	end

	if self:GetAmmoBank() < ammototake then
		self:SetNextPrimaryFire( CurTime() + self:GetFiremodeTable().Delay )
		self:SetBurstCount( self:GetBurstCount() + 1 )
		self:EmitSound( "Weapon_Pistol.Empty" )
		return false
	end

	self:TakePrimaryAmmo( ammototake )
	self:SetNextPrimaryFire( CurTime() + self:GetFiremodeTable().Delay )
	self:SetBurstCount( self:GetBurstCount() + 1 )
	self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )

	self:SendAnim( ACT_VM_PRIMARYATTACK )

	-- Bullets
	local bullet = {
		RangeNear = self.RangeNear / HUToM,
		RangeFar = self.RangeFar / HUToM,
		DamageNear = self.DamageNear,
		DamageFar = self.DamageFar,
	}
	self:FireBullet(bullet)

	-- Recoil
	local p = self:GetOwner()
	if !IsValid(p) then p = false end
	if p then
		local fli = self:GetRecoilFlip() and -1 or 1
		local ads = Lerp( self:GetSightDelta(), 1, self.RecoilADSMult )
		if true then
			if CLIENT and IsFirstTimePredicted() then p:SetEyeAngles( p:EyeAngles() + Angle( ads * -self.RecoilUp * (1-self.RecoilUpDrift), ads * fli * self.RecoilSide * (1-self.RecoilSideDrift) ) ) end
			self:SetRecoilP( self:GetRecoilP() + (ads * -self.RecoilUp * self.RecoilUpDrift) )
			self:SetRecoilY( self:GetRecoilY() + (ads * fli * -self.RecoilSide * self.RecoilSideDrift) )
		end
		if util.SharedRandom( "recoilflipinit", 0, 1, CurTime() ) < self.RecoilFlipChance then
			self:SetRecoilFlip( !self:GetRecoilFlip() )
		end
	end
	
	return true
end

local LimbCompensation = {
	--[HITGROUP_HEAD]     = 1 / 2.5,
	[HITGROUP_LEFTARM]  = 1 / 0.55,
	[HITGROUP_RIGHTARM] = 1 / 0.55,
	[HITGROUP_LEFTLEG]  = 1 / 0.55,
	[HITGROUP_RIGHTLEG] = 1 / 0.55,
	[HITGROUP_GEAR]     = 1 / 0.55,
}

-- Bullets
function SWEP:FireBullet(bullet)
	local dir = self:GetOwner():EyeAngles()
	local dispersion = self:GetDispersion()
	local shared_rand = CurTime()
	local x = util.SharedRandom(shared_rand, -0.5, 0.5) + util.SharedRandom(shared_rand + 1, -0.5, 0.5)
	local y = util.SharedRandom(shared_rand + 2, -0.5, 0.5) + util.SharedRandom(shared_rand + 3, -0.5, 0.5)
	dir = dir:Forward() + (x * math.rad(dispersion) * dir:Right()) + (y * math.rad(dispersion) * dir:Up())

	bullet.Src = self:GetOwner():GetShootPos()
	bullet.Dir = dir
	bullet.Distance = 32768

	bullet.Callback = function( atk, tr, dmg )
		-- Thank you Arctic, very cool
		local ent = tr.Entity

		if self.CustomCallback then self:CustomCallback( atk, tr, dmg ) end

		dmg:SetDamage( bullet.DamageNear )
		dmg:SetDamageType( DMG_BULLET )

		local d = dmg:GetDamage()
		local min, max = bullet.RangeNear, bullet.RangeFar
		local range = atk:GetPos():Distance(tr.HitPos)
		local XD = 0
		if range < min then
			XD = 0
		else
			XD = math.Clamp((range - min) / (max - min), 0, 1)
		end

		dmg:SetDamage( Lerp( 1-XD, bullet.DamageFar, bullet.DamageNear ) )

		self:SetNWString( "TestRange", math.Round( (1-XD)*100 ) .. "% effectiveness, " .. math.Round( dmg:GetDamage() ) .. " dmg" )

		if IsValid(ent) and ent:IsPlayer() then
			local hg = tr.HitGroup
			local gam = LimbCompensation
			local gem = self.BodyDamageMults
			if gem[hg] then dmg:ScaleDamage(gem[hg]) end
			if gam[hg] then dmg:ScaleDamage(gam[hg]) end
		end
		return
	end

	self:GetOwner():FireBullets( bullet )
end

function SWEP:GetHeadshotMultiplier(victim, dmginfo)
	return 1
end

function SWEP:DrawHUD()
	if self.CustomDrawHUD then self:CustomDrawHUD() end
	draw.SimpleText( self:GetNWString("TestRange", "no data"), "Trebuchet24", ScrW()/2, ScrH()*0.75, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText( self:GetNWString("TestDisp", "no data"), "Trebuchet24", ScrW()/2, ScrH()*0.8, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

-- No secondary
function SWEP:SecondaryAttack()
end

--
-- Reloading
--
function SWEP:Reload()
	if self:GetNextPrimaryFire() > CurTime() then
		return false
	end

	if self:GetReloadingTime() > CurTime() then
		return false
	end

	if self:RefillCount() > 0 then
		self:SendAnim( ACT_VM_RELOAD, "reload" )
	end

	return true
end

function SWEP:RefillCount(amount)
	local spent = self:GetMaxClip1() - self:Clip1()
	local refill = math.min( spent, self:Ammo1(), (amount or math.huge) )

	return refill
end

function SWEP:Refill()
	local refill = self:RefillCount()

	--assert( refill > 0, "Refill is lower than 0!" )

	self:GetOwner():SetAmmo( self:Ammo1() - refill, self:GetPrimaryAmmoType() )
	self:SetClip1( self:Clip1() + refill )
end

function SWEP:TakePrimaryAmmo( amount )
	assert( self:Clip1() - amount >= 0, "Trying to reduce ammo below zero!" )

	self:SetClip1( self:Clip1() - 1 )
end

function SWEP:GetAmmoBank()
	return self:Clip1()
end

CreateClientConVar( "ttt_a_toggleads", 0, true, true )

-- Thinking
function SWEP:Think()
	-- local runoff = self:GetFiremodeTable().Runoff
	-- if runoff and self:GetBurstCount() != 0 then
	-- 	if ( (game.SinglePlayer() and SERVER) or !game.SinglePlayer() ) then
	-- 		self:PrimaryAttack()
	-- 	end
	-- end
	if self:GetBurstCount() >= self:GetFiremodeTable().Count then
		self:SetBurstCount( 0 )
		self:SetNextMechFire( CurTime() + (self:GetFiremodeTable().PostBurstDelay or 0) ) -- Can feel uncomfortable.
		self:SetFiredLastShot( true )
	elseif !self:GetOwner():KeyDown(IN_ATTACK) and self:GetBurstCount() != 0 then
		self:SetBurstCount( 0 )
		self:SetNextMechFire( CurTime() + (self:GetFiremodeTable().PostBurstDelay or 0) ) -- Can feel uncomfortable.
	end
	if !self:GetOwner():KeyDown(IN_ATTACK) then
		self:SetFiredLastShot(false)
	end

	if self:GetOwner():GetInfoNum("ttt_a_toggleads", 0) == 0 then
		self:SetUserSight( self:GetOwner():KeyDown(IN_ATTACK2) )
	else
		if self:GetReloadingTime() > CurTime() then
			self:SetUserSight( false )
		elseif self:GetOwner():KeyPressed(IN_ATTACK2) then
			self:SetUserSight( !self:GetUserSight() )
		end
	end
	local capableofads = self:GetStopSightTime() <= CurTime() and !self:GetOwner():IsSprinting() -- replace with GetReloading
	self:SetSightDelta( math.Approach( self:GetSightDelta(), (capableofads and self:GetUserSight() and 1 or 0), FrameTime() / 0.4 ) )

	if self:GetLoadIn() > 0 and self:GetLoadIn() <= CurTime() then
		self:Refill(self:Clip1())
		self:SetLoadIn(-1)
	end

	local p = self:GetOwner()
	if !IsValid(p) then p = false end
	if p then
		local rp = self:GetRecoilP()
		local ry = self:GetRecoilY()
		if rp != 0 then
			local remove = rp - math.Approach( rp, 0, FrameTime() * self.RecoilUpDecay )
			if CLIENT and IsFirstTimePredicted() then p:SetEyeAngles( p:EyeAngles() + ( Angle( remove, 0 ) ) ) end
			self:SetRecoilP( rp - remove )
		end
		if ry != 0 then
			local remove = ry - math.Approach( ry, 0, FrameTime() * self.RecoilSideDecay )
			if CLIENT and IsFirstTimePredicted() then p:SetEyeAngles( p:EyeAngles() - ( Angle( 0, remove ) ) ) end
			self:SetRecoilY( math.Approach( ry, ry - remove, math.huge ) )
		end
		local ht = self.HoldTypeHip
		if self:GetSightDelta() > 0.2 then
			ht = self.HoldTypeSight
		end
		self:SetHoldType( ht )
		self:SetWeaponHoldType( ht )

		local movem = p:GetAbsVelocity():Length2D()
		movem = math.TimeFraction( 100, 200, movem )
		movem = math.Clamp( movem, 0, 1 )
		self:SetDISP_Air( math.Approach( self:GetDISP_Air(), p:OnGround() and 0 or 1, FrameTime() / 0.2 ) )
		self:SetDISP_Move( math.Approach( self:GetDISP_Move(), movem, FrameTime() / 0.2 ) )
		self:SetDISP_Crouch( math.Approach( self:GetDISP_Crouch(), p:Crouching() and 1 or 0, FrameTime() / 0.4 ) )
	end
	
	if self:GetIdleIn() > 0 and self:GetIdleIn() <= CurTime() then
		self:SendAnim( ACT_VM_IDLE, "idle" )
		self:SetPlaybackRate( 1 )
		self:SetIdleIn( -1 )
	end
end

-- Animating
local fallback = {
	Mult = 1,
}
function SWEP:SendAnim( act, hold )
	local anim = self.AnimOverride--[act]
	if !anim then
		anim = fallback
		anim.Source = act
	else
		anim = self.AnimOverride[act]
	end
	local mult = anim.Mult or 1
	self:SendWeaponAnim( anim.Source )
	self:SetPlaybackRate( mult )
	self:GetOwner():GetViewModel():SetPlaybackRate( mult )
	if hold == "idle" then
		hold = false
	else
		self:SetIdleIn( CurTime() + (self:SequenceDuration() / mult) )
	end

	local stopsight = hold
	local reloadtime = hold
	local loadin = hold == "reload"
	local suppresstime = false

	if anim.StopSightTime then
		stopsight = true
	end
	if anim.ReloadingTime then
		reloadtime = true
	end
	if anim.LoadIn then
		loadin = true
	end
	if anim.SuppressTime then
		suppresstime = true
	end

	if reloadtime then
		self:SetReloadingTime( CurTime() + (anim.ReloadingTime or self:SequenceDuration() / mult) )
	end
	if stopsight then
		self:SetStopSightTime( CurTime() + (anim.StopSightTime or self:SequenceDuration() / mult) )
	end
	if loadin then
		self:SetLoadIn( CurTime() + (anim.LoadIn or self:SequenceDuration() / mult) )
	end
	if suppresstime then
		self:SetSuppressIn( CurTime() + (anim.SuppressTime or self:SequenceDuration() / mult) )
	end

end

-- Aiming
function SWEP:TranslateFOV(fov)
	local mag = 1.1
	if self.IronsightPos and self.IronsightPos.Mag then
		mag = self.IronsightPos.Mag
	end
	return fov / Lerp( math.ease.InOutQuad( self:GetSightDelta() ), 1, mag )
end


function SWEP:AdjustMouseSensitivity()
	local mag = 1.1
	if self.IronsightPos and self.IronsightPos.Mag then
		mag = self.IronsightPos.Mag
	end
	return 1 / Lerp( math.ease.InOutQuad( self:GetSightDelta() ), 1, mag )
end

-- Deploy and holster
function SWEP:Deploy()
	self:SendAnim( ACT_VM_DRAW, true )
	return true
end

function SWEP:Holster()
	self:SetLoadIn( -1 )
	self:SetSightDelta( 0 )
	return true
end

SWEP.BobScale = 0
SWEP.SwayScale = 0
local savemoove = 0

local ttt_lower = Vector(0, 0, -1.2)

function SWEP:GetViewModelPosition(pos, ang)
	local opos, oang = Vector(), Angle()
	local p = self:GetOwner()

	if IsValid(p) then

	do -- ironsighting
		local b_pos, b_ang = Vector(), Angle()
		local si = 1-self:GetSightDelta()

		b_pos:Add( self.ActivePos.Pos )
		b_pos:Mul( math.ease.InOutSine( si ) )
		b_ang:Add( self.ActivePos.Ang )
		b_ang:Mul( math.ease.InOutSine( si ) )

		opos:Add( b_pos )
		oang:Add( b_ang )
	end

	do -- ironsighting
		local b_pos, b_ang = Vector(), Angle()
		local si = self:GetSightDelta()

		if self.IronsightPos then
			b_pos:Add( self.IronsightPos.Pos )
			b_ang:Add( self.IronsightPos.Ang )
		else
			b_pos:Add( self.IronSightsPos )
			if isvector( self.IronSightsAng ) then
				-- fucking bastards
				self.IronSightsAng = Angle(self.IronSightsAng.x, self.IronSightsAng.y, self.IronSightsAng.z)
			end
			b_ang:Add( self.IronSightsAng )
		end
		if GetConVar("ttt_ironsights_lowered"):GetBool() then
			b_pos:Add( ttt_lower )
		end
		b_pos:Mul( math.ease.InOutSine( si ) )
		b_ang:Mul( math.ease.InOutSine( si ) )

		opos:Add( b_pos )
		oang:Add( b_ang )
		
		
		local b_pos, b_ang = Vector(), Angle()
		local xi = si

		if xi >= 0.5 then
			xi = xi - 0.5
			xi = 0.5 - xi
		end
		xi = xi * 2

		b_pos:Add( Vector( -0.5, -2, -0 ) )
		b_pos:Mul( math.ease.InOutSine( xi ) )
		b_ang:Add( Angle( -4, 0, -5 ) )
		b_ang:Mul( math.ease.InOutSine( xi ) )

		opos:Add( b_pos )
		oang:Add( b_ang )
	end

	if true then -- bobbing
		local b_pos, b_ang = Vector(), Angle()
		local speed = 2 -- This can't be changed in real time or it'll look juttery.

		local new = p:GetAbsVelocity():Length()/200
		local time = 0.4
		if new < savemoove then
			time = 0.7
		end
		savemoove = math.Approach( savemoove, new, FrameTime() / time )

		local moove = Lerp( self:GetSightDelta(), savemoove, math.min(savemoove, 0.1) )

		b_pos.x = math.sin( CurTime() * math.pi * speed ) * 0.5
		b_pos.z = math.cos( CurTime() * math.pi * speed * 2 ) * -0.1

		b_ang.x = math.sin( CurTime() * math.pi * speed * 2 ) * -0.2
		b_ang.y = math.cos( CurTime() * math.pi * speed * 1 ) * 1

		b_pos:Mul( moove )
		b_ang:Mul( moove )

		opos:Add(b_pos)
		oang:Add(b_ang)
	end

	end
	
	ang:RotateAroundAxis( ang:Right(),		oang.x )
	ang:RotateAroundAxis( ang:Up(),			oang.y )
	ang:RotateAroundAxis( ang:Forward(),	oang.z )

	pos:Add( opos.x * ang:Right() )
	pos:Add( opos.y * ang:Forward() )
	pos:Add( opos.z * ang:Up() )

	return pos, ang
end

function SWEP:GetDispersion()
	local disp = self.Dispersion

	disp = disp + ( self:GetDISP_Air() * self.Dispersion_Air )
	disp = disp + ( self:GetDISP_Move() * self.Dispersion_Move )

	disp = Lerp( self:GetDISP_Crouch(), disp, disp * self.Dispersion_Crouch )
	disp = Lerp( self:GetSightDelta(), disp, disp * self.Dispersion_Sights )

	self:SetNWString( "TestDisp", math.Round(disp, 1) .. " degrees" )

	return disp
end

--
-- HUD, UI, Crosshair
--

local CHR_F = Color( 255, 242, 151, 255 )
local CHR_B = Color( 0, 0, 0, 100 )
local CHR_S = Color( 255, 255, 255, 255 )
local len = 1.0
local thi = 1.0
local gap = 10
local sd = 1
local reloadclock = 0

function SWEP:DoDrawCrosshair()
	local l = ScreenScale(len)
	local t = ScreenScale(thi)
	local s = sd
	local p = self:GetOwner()

	local dispersion = math.rad(self:GetDispersion())
	cam.Start3D()
		local lool = ( EyePos() + ( EyeAngles():Forward() ) + ( dispersion * EyeAngles():Up() ) ):ToScreen()
	cam.End3D()

	local gau = (ScrH()/2)
	gau = ( gau - lool.y )
	gap = gau

	if p.IsDetective and p:IsDetective() then
		CHR_F = Color( 0, 255, 255, 255 )
		CHR_B = Color( 0, 0, 0, 100 )
	elseif p.IsTraitor and p:IsTraitor() then
		CHR_F = Color( 255, 50, 50, 255 )
		CHR_B = Color( 100, 100, 200, 100 )
	else
		CHR_F = Color( 0, 255, 0, 255 )
		CHR_B = Color( 0, 0, 0, 100 )
	end
	
	--[[
	if self.IronSights.Scope then
		local sick = Lerp( math.TimeFraction( 0.6, 0.8, self:GetSightDelta() ), 0, 1 )
		CHR_S.a = sick * 255
		surface.SetDrawColor( CHR_S )
		local mat = self.IronSights.Scope
		if isnumber( si[mat] ) then
			mat = si[mat]
		end
		if isnumber( mat ) then
			surface.SetTexture( mat )
		else
			surface.SetMaterial( mat )
		end
		local gaap = gap
		local size = ScrH()--( ScrH() * 1 ) + ( gaap * ScrH() )
		size = size * 1.4
		size = size + ( gap * ScrH() * 0.01 )
		size = size * (0.8+(sick*0.2))
		surface.DrawTexturedRect( ( ScrW() / 2 ) - ( size / 2 ), ( ScrH() / 2 ) - ( size / 2 ), size, size)
	end
	]]

	if false then
		reloadclock = math.Approach( reloadclock, (self:GetReloadingTime() > CurTime()) and 1 or 0, FrameTime() / 0.4 )
		local clock = Lerp( math.max( self:GetSightDelta(), reloadclock ), 1, 0 )
		CHR_F.a = clock * 255
		CHR_B.a = clock * 100
		gap = gap / (clock)
		l = l * clock
	end

	-- bg
	surface.SetDrawColor( CHR_B )
	-- bottom prong
	surface.DrawRect( math.Round(( ScrW() / 2 ) - ( t / 2 ) + s), math.Round(( ScrH() / 2 ) + gap + s), t, l )

	-- top prong
	surface.DrawRect( math.Round(( ScrW() / 2 ) - ( t / 2 ) + s), math.Round(( ScrH() / 2 ) - l - gap + s), t, l )

	-- left prong
	surface.DrawRect( math.Round(( ScrW() / 2 ) - l - gap + s), math.Round(( ScrH() / 2 ) - ( t / 2 ) + s), l, t )

	-- right prong
	surface.DrawRect( math.Round(( ScrW() / 2 ) + gap + s), math.Round(( ScrH() / 2 ) - ( t / 2 ) + s), l, t )

	-- center
	surface.DrawRect( math.Round(( ScrW() / 2 ) - ( t / 2 ) + s), math.Round(( ScrH() / 2 ) - ( t / 2 ) + s), t, t )

	-- fore
	surface.SetDrawColor( CHR_F )
	-- bottom prong
	surface.DrawRect( math.Round(( ScrW() / 2 ) - ( t / 2 )), math.Round(( ScrH() / 2 ) + gap), t, l )

	-- top prong
	surface.DrawRect( math.Round(( ScrW() / 2 ) - ( t / 2 )), math.Round(( ScrH() / 2 ) - l - gap), t, l )

	-- left prong
	surface.DrawRect( math.Round(( ScrW() / 2 ) - l - gap), math.Round(( ScrH() / 2 ) - ( t / 2 )), l, t )

	-- right prong
	surface.DrawRect( math.Round(( ScrW() / 2 ) + gap), math.Round(( ScrH() / 2 ) - ( t / 2 )), l, t )

	-- center
	surface.DrawRect( math.Round(( ScrW() / 2 ) - ( t / 2 )), math.Round(( ScrH() / 2 ) - ( t / 2 )), t, t )
	return true
end


-- uhhhh
-- replacements,

SWEP.StoredAmmo = 0
SWEP.IsDropped = false
local SF_WEAPON_START_CONSTRAINED = 1

-- Picked up by player. Transfer of stored ammo and such.
function SWEP:Equip(newowner)
	if SERVER then
		if self:IsOnFire() then
			self:Extinguish()
		end

		self.fingerprints = self.fingerprints or {}

		if not table.HasValue(self.fingerprints, newowner) then
			table.insert(self.fingerprints, newowner)
		end

		if self:HasSpawnFlags(SF_WEAPON_START_CONSTRAINED) then
			-- If this weapon started constrained, unset that spawnflag, or the
			-- weapon will be re-constrained and float
			local flags = self:GetSpawnFlags()
			local newflags = bit.band(flags, bit.bnot(SF_WEAPON_START_CONSTRAINED))
			self:SetKeyValue("spawnflags", newflags)
		end
	end

	if SERVER and IsValid(newowner) and self.StoredAmmo > 0 and self.Primary.Ammo != "none" then
		local ammo = newowner:GetAmmoCount(self.Primary.Ammo)
		local given = math.min(self.StoredAmmo, self.Primary.ClipMax - ammo)

		newowner:GiveAmmo( given, self.Primary.Ammo)
		self.StoredAmmo = 0
	end
end

-- The OnDrop() hook is useless for this as it happens AFTER the drop. OwnerChange
-- does not occur when a drop happens for some reason. Hence this thing.
function SWEP:PreDrop()
	if SERVER and IsValid(self:GetOwner()) and self.Primary.Ammo != "none" then
		local ammo = self:Ammo1()

		-- Do not drop ammo if we have another gun that uses this type
		for _, w in ipairs(self:GetOwner():GetWeapons()) do
			if IsValid(w) and w != self and w:GetPrimaryAmmoType() == self:GetPrimaryAmmoType() then
				ammo = 0
			end
		end

		self.StoredAmmo = ammo

		if ammo > 0 then
			self:GetOwner():RemoveAmmo(ammo, self.Primary.Ammo)
		end
	end
end

function SWEP:DampenDrop()
	-- For some reason gmod drops guns on death at a speed of 400 units, which
	-- catapults them away from the body. Here we want people to actually be able
	-- to find a given corpse's weapon, so we override the velocity here and call
	-- this when dropping guns on death.
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocityInstantaneous(Vector(0,0,-75) + phys:GetVelocity() * 0.001)
		phys:AddAngleVelocity(phys:GetAngleVelocity() * -0.99)
	end
end

-- ttt slowdown integration
function SWEP:GetIronsights()
	return (self:GetSightDelta() > 0.7)
end

function SWEP:IsEquipment()
	return false
end

SWEP.HeadshotMultiplier = 2.7

SWEP.StoredAmmo = 0
SWEP.IsDropped = false

SWEP.DeploySpeed = 1.4

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.ReloadAnim = ACT_VM_RELOAD

SWEP.fingerprints = {}