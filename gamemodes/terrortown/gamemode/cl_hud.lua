-- HUD HUD HUD

local table = table
local surface = surface
local draw = draw
local math = math
local string = string

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation
local GetLang = LANG.GetUnsafeLanguageTable
local interp = string.Interp

-- Fonts
surface.CreateFont("TraitorState", {font = "Trebuchet24",
                                    size = 28,
                                    weight = 1000})
surface.CreateFont("TimeLeft",     {font = "Trebuchet24",
                                    size = 24,
                                    weight = 800})
surface.CreateFont("HealthAmmo",   {font = "Trebuchet24",
                                    size = 24,
                                    weight = 750})
-- Color presets
local bg_colors = {
   background_main = Color(0, 0, 10, 200),

   noround = Color(100,100,100,200),
   traitor = Color(200, 25, 25, 200),
   innocent = Color(25, 200, 25, 200),
   detective = Color(25, 25, 200, 200)
};

local health_colors = {
   border = COLOR_WHITE,
   background = Color(100, 25, 25, 222),
   fill = Color(200, 50, 50, 250)
};

local ammo_colors = {
   border = COLOR_WHITE,
   background = Color(20, 20, 5, 222),
   fill = Color(205, 155, 0, 255)
};


-- Modified RoundedBox
local Tex_Corner8 = surface.GetTextureID( "gui/corner8" )
local function RoundedMeter( bs, x, y, w, h, color)
   surface.SetDrawColor(clr(color))

   surface.DrawRect( x+bs, y, w-bs*2, h )
   surface.DrawRect( x, y+bs, bs, h-bs*2 )

   surface.SetTexture( Tex_Corner8 )
   surface.DrawTexturedRectRotated( x + bs/2 , y + bs/2, bs, bs, 0 )
   surface.DrawTexturedRectRotated( x + bs/2 , y + h -bs/2, bs, bs, 90 )

   if w > 14 then
      surface.DrawRect( x+w-bs, y+bs, bs, h-bs*2 )
      surface.DrawTexturedRectRotated( x + w - bs/2 , y + bs/2, bs, bs, 270 )
      surface.DrawTexturedRectRotated( x + w - bs/2 , y + h - bs/2, bs, bs, 180 )
   else
      surface.DrawRect( x + math.max(w-bs, bs), y, bs/2, h )
   end

end

---- The bar painting is loosely based on:
---- http://wiki.garrysmod.com/?title=Creating_a_HUD

-- Paints a graphical meter bar
local function PaintBar(x, y, w, h, colors, value)
   -- Background
   -- slightly enlarged to make a subtle border
   draw.RoundedBox(8, x-1, y-1, w+2, h+2, colors.background)

   -- Fill
   local width = w * math.Clamp(value, 0, 1)

   if width > 0 then
      RoundedMeter(8, x, y, width, h, colors.fill)
   end
end

local roundstate_string = {
   [ROUND_WAIT]   = "round_wait",
   [ROUND_PREP]   = "round_prep",
   [ROUND_ACTIVE] = "round_active",
   [ROUND_POST]   = "round_post"
};

-- Returns player's ammo information
local function GetAmmo(ply)
   local weap = ply:GetActiveWeapon()
   if not weap or not ply:Alive() then return -1 end

   local ammo_inv = weap:Ammo1() or 0
   local ammo_clip = weap:Clip1() or 0
   local ammo_max = weap.Primary.ClipSize or 0

   return ammo_clip, ammo_max, ammo_inv
end

local function DrawBg(x, y, width, height, client)
   -- Traitor area sizes
   local th = 30
   local tw = 170

   -- Adjust for these
   y = y - th
   height = height + th

   -- main bg area, invariant
   -- encompasses entire area
   draw.RoundedBox(8, x, y, width, height, bg_colors.background_main)

   -- main border, traitor based
   local col = bg_colors.innocent
   if GAMEMODE.round_state != ROUND_ACTIVE then
      col = bg_colors.noround
   elseif client:GetTraitor() then
      col = bg_colors.traitor
   elseif client:GetDetective() then
      col = bg_colors.detective
   end

   draw.RoundedBox(8, x, y, tw, th, col)
end

local sf = surface
local dr = draw

local function ShadowedText(text, font, x, y, color, xalign, yalign)

   dr.SimpleText(text, font, x+2, y+2, COLOR_BLACK, xalign, yalign)

   dr.SimpleText(text, font, x, y, color, xalign, yalign)
end

local margin = 10

-- Paint punch-o-meter
local function PunchPaint(client)
   local L = GetLang()
   local punch = client:GetNWFloat("specpunches", 0)

   local width, height = 200, 25
   local x = ScrW() / 2 - width/2
   local y = margin/2 + height

   PaintBar(x, y, width, height, ammo_colors, punch)

   local color = bg_colors.background_main

   dr.SimpleText(L.punch_title, "HealthAmmo", ScrW() / 2, y, color, TEXT_ALIGN_CENTER)

   dr.SimpleText(L.punch_help, "TabLarge", ScrW() / 2, margin, COLOR_WHITE, TEXT_ALIGN_CENTER)

   local bonus = client:GetNWInt("bonuspunches", 0)
   if bonus != 0 then
      local text
      if bonus < 0 then
         text = interp(L.punch_bonus, {num = bonus})
      else
         text = interp(L.punch_malus, {num = bonus})
      end

      dr.SimpleText(text, "TabLarge", ScrW() / 2, y * 2, COLOR_WHITE, TEXT_ALIGN_CENTER)
   end
end

local key_params = { usekey = Key("+use", "USE") }

local function SpecHUDPaint(client)
   local L = GetLang() -- for fast direct table lookups

   -- Draw round state
   local x       = margin
   local height  = 32
   local width   = 250
   local round_y = ScrH() - height - margin

   -- move up a little on low resolutions to allow space for spectator hints
   if ScrW() < 1000 then round_y = round_y - 15 end

   local time_x = x + 170
   local time_y = round_y + 4

   draw.RoundedBox(8, x, round_y, width, height, bg_colors.background_main)
   draw.RoundedBox(8, x, round_y, time_x - x, height, bg_colors.noround)

   local text = L[ roundstate_string[GAMEMODE.round_state] ]
   ShadowedText(text, "TraitorState", x + margin, round_y, COLOR_WHITE)

   -- Draw round/prep/post time remaining
   local text = util.SimpleTime(math.max(0, GetGlobalFloat("ttt_round_end", 0) - CurTime()), "%02i:%02i")
   ShadowedText(text, "TimeLeft", time_x + margin, time_y, COLOR_WHITE)

   local tgt = client:GetObserverTarget()
   if IsValid(tgt) and tgt:IsPlayer() then
      ShadowedText(tgt:Nick(), "TimeLeft", ScrW() / 2, margin, COLOR_WHITE, TEXT_ALIGN_CENTER)

   elseif IsValid(tgt) and tgt:GetNWEntity("spec_owner", nil) == client then
      PunchPaint(client)
   else
      ShadowedText(interp(L.spec_help, key_params), "TabLarge", ScrW() / 2, margin, COLOR_WHITE, TEXT_ALIGN_CENTER)
   end
end

local ttt_health_label = CreateClientConVar("ttt_health_label", "0", true)

local function InfoPaint(client)
   local L = GetLang()

   local width = 250
   local height = 90

   local x = margin
   local y = ScrH() - margin - height

   DrawBg(x, y, width, height, client)

   local bar_height = 25
   local bar_width = width - (margin*2)

   -- Draw health
   local health = math.max(0, client:Health())
   local health_y = y + margin

   PaintBar(x + margin, health_y, bar_width, bar_height, health_colors, health/client:GetMaxHealth())

   ShadowedText(tostring(health), "HealthAmmo", bar_width, health_y, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)

   if ttt_health_label:GetBool() then
      local health_status = util.HealthToString(health, client:GetMaxHealth())
      draw.SimpleText(L[health_status], "TabLarge", x + margin*2, health_y + bar_height/2, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
   end

   -- Draw ammo
   if client:GetActiveWeapon().Primary then
      local ammo_clip, ammo_max, ammo_inv = GetAmmo(client)
      if ammo_clip != -1 then
         local ammo_y = health_y + bar_height + margin
         PaintBar(x+margin, ammo_y, bar_width, bar_height, ammo_colors, ammo_clip/ammo_max)
         local text = string.format("%i + %02i", ammo_clip, ammo_inv)

         ShadowedText(text, "HealthAmmo", bar_width, ammo_y, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
      end
   end

   -- Draw traitor state
   local round_state = GAMEMODE.round_state

   local traitor_y = y - 30
   local text = nil
   if round_state == ROUND_ACTIVE then
      text = L[ client:GetRoleStringRaw() ]
   else
      text = L[ roundstate_string[round_state] ]
   end

   ShadowedText(text, "TraitorState", x + margin + 73, traitor_y, COLOR_WHITE, TEXT_ALIGN_CENTER)

   -- Draw round time
   local is_haste = HasteMode() and round_state == ROUND_ACTIVE
   local is_traitor = client:IsActiveTraitor()

   local endtime = GetGlobalFloat("ttt_round_end", 0) - CurTime()

   local text
   local font = "TimeLeft"
   local color = COLOR_WHITE
   local rx = x + margin + 170
   local ry = traitor_y + 3

   -- Time displays differently depending on whether haste mode is on,
   -- whether the player is traitor or not, and whether it is overtime.
   if is_haste then
      local hastetime = GetGlobalFloat("ttt_haste_end", 0) - CurTime()
      if hastetime < 0 then
         if (not is_traitor) or (math.ceil(CurTime()) % 7 <= 2) then
            -- innocent or blinking "overtime"
            text = L.overtime
            font = "Trebuchet18"

            -- need to hack the position a little because of the font switch
            ry = ry + 5
            rx = rx - 3
         else
            -- traitor and not blinking "overtime" right now, so standard endtime display
            text  = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
            color = COLOR_RED
         end
      else
         -- still in starting period
         local t = hastetime
         if is_traitor and math.ceil(CurTime()) % 6 < 2 then
            t = endtime
            color = COLOR_RED
         end
         text = util.SimpleTime(math.max(0, t), "%02i:%02i")
      end
   else
      -- bog standard time when haste mode is off (or round not active)
      text = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
   end

   ShadowedText(text, font, rx, ry, color)

   if is_haste then
      dr.SimpleText(L.hastemode, "TabLarge", x + margin + 165, traitor_y - 8)
   end

end

local fonts_to_make = {
	["Bahnschrift"] = {
		6,
		8,
		10,
		12,
		18,
		24,
		36,
	},
}

for aa, bb in pairs(fonts_to_make) do
	for cc, dd in pairs(bb) do
		surface.CreateFont("ATTT_" .. aa .. "_" .. dd, {
			font = aa,
			size = ScreenScale(dd),
			weight = 0,
		})
	end
end

local CLR_R = Color(255, 100, 0, 255)
local CLR_W = Color(255, 255, 255, 255)
local CLR_B = Color(0, 0, 0, 100)
local CLR_RR = Color(255, 255, 255, 255)
local MAT_DOT = Material( "attt/dot.png", "smooth" )
local MAT_TRI = Material( "attt/tri.png", "" )

local COL_TRAITOR		= Color(216, 51, 51)
local COL_INNOCENT		= Color(63, 195, 63)
local COL_DETECTIVE		= Color(32, 74, 171)
local COL_NOROUND		= Color(100, 100, 100)

local COL_SURVIVALIST	= Color(253, 161, 39)
local COL_PHOENIX		= Color(107, 157, 243)

local function ATTT_TextS(text, font, x, y, color, ax, ay)
	local c = ScreenScale(1)

	draw.SimpleText(text, font, x + (c*1), y + (c*1), CLR_B, ax, ay)
	draw.SimpleText(text, font, x, y, color, ax, ay)
end

local function ATTT_RectS(x, y, w, h, t, clr)
	local c = ScreenScale(1)

	surface.SetDrawColor( CLR_B )
	surface.DrawOutlinedRect(x + (c*1), y + (c*1), w, h, t)
	surface.SetDrawColor( clr )
	surface.DrawOutlinedRect(x, y, w, h, t)
end

local function ATTT_HUD(p)
	local c = ScreenScale(1)
	local w, h = ScrW(), ScrH()
	local ow, oh = (c*8), (c*8)

	-- Draw traitor state
	local round_state = GAMEMODE.round_state

	local Role = nil
	local RoleA = nil
	if round_state == ROUND_ACTIVE then
		Role = p:GetRoleStringRaw()
	else
		Role = roundstate_string[round_state]
	end

	local col = color_white
	local cola
	if Role == "round_post" then
		col = COL_NOROUND
		Role = "Round over"
	elseif Role == "round_prep" then
		col = COL_NOROUND
		Role = "Preparing"
	elseif Role == "innocent" then
		col = COL_INNOCENT
		Role = "Innocent"
		local ra = p:GetRoleAdditive()
		if ra == ROLE_A_NONE then
		elseif ra == ROLE_A_SURVIVALIST then
			RoleA = "Survivalist"
			cola = COL_SURVIVALIST
		elseif ra == ROLE_A_PHOENIX then
			RoleA = "Phoenix"
			cola = COL_PHOENIX
		end
	elseif Role == "traitor" then
		col = COL_TRAITOR
		Role = "Traitor"
	elseif Role == "detective" then
		col = COL_DETECTIVE
		Role = "Detective"
	end

   -- Draw round time
   local is_haste = HasteMode() and round_state == ROUND_ACTIVE
   local is_traitor = p:IsActiveTraitor()

   local endtime = GetGlobalFloat("ttt_round_end", 0) - CurTime()

   local str_time = "00"
   local str_font = "ATTT_Bahnschrift_12"
   local font = "TimeLeft"
   local color = CLR_W

	-- Time displays differently depending on whether haste mode is on,
	-- whether the player is traitor or not, and whether it is overtime.
	if is_haste then
		local hastetime = GetGlobalFloat("ttt_haste_end", 0) - CurTime()
		if hastetime < 0 then
			if (!is_traitor) then
				-- innocent
				str_time = "OVERTIME"
				str_font = "ATTT_Bahnschrift_8"
			else
				-- traitor
				str_time  = util.SimpleTime(math.max(0, endtime), "%01i:%02i")
				color = CLR_R
			end
		else
			-- still in starting period
			local t = hastetime
			if is_traitor and math.ceil(CurTime()) % 6 < 2 then
				t = endtime
				color = CLR_R
			end
			str_time = util.SimpleTime(math.max(0, t), "%01i:%02i")
		end
	else
		-- bog standard time when haste mode is off (or round not active)
		str_time = util.SimpleTime(math.max(0, endtime), "%01i:%02i")
	end

	draw.RoundedBoxEx( (c*16), 0, h - (c*58), (c*118), (c*58), CLR_B, false, true, false, false )
	draw.RoundedBoxEx( (c*16), 0, h - (c*44) - (c*14), (c*64), (c*14), cola or col, false, true, false, true )
	
	if RoleA then
		surface.SetMaterial( MAT_TRI )
		surface.SetDrawColor( col )
		surface.DrawTexturedRect( 0, h - (c*44) - (c*14), (c*14), (c*14) )
	end
	ATTT_TextS( RoleA or Role, "ATTT_Bahnschrift_12", (c*31), h - (c*45.5), CLR_W, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )

	ATTT_TextS( p:Health(), "ATTT_Bahnschrift_24", (c*16), h - (c*8) - (c*9), CLR_W, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
	ATTT_TextS( str_time, str_font, (c*88), h - (c*51.5), color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	ATTT_RectS( ow, h - oh - (c*7), (c*100), (c*7), (c*1.5), CLR_W )
	surface.SetDrawColor( CLR_W )
	surface.DrawRect( ow, h - oh - (c*7), (c*100) * math.Clamp(p:Health()/p:GetMaxHealth(), 0, 1), (c*7) )

	surface.SetMaterial( MAT_DOT )
	surface.SetDrawColor( CLR_B )
	surface.DrawTexturedRect( (c*9) + (c*1), h - (c*35) + (c*1), (c*5), (c*5) )
	surface.SetDrawColor( CLR_W )
	surface.DrawTexturedRect( (c*9), h - (c*35), (c*5), (c*5) )

	local we = p:GetActiveWeapon()
	if !IsValid(we) then we = false end
	if !(WSWITCH and WSWITCH.Show) and we and we.Primary and we:Clip1() >= 0 then
		draw.RoundedBoxEx( (c*16), w - (c*118), h - (c*44), (c*118), (c*44), CLR_B, true, false, false, false )
		if we.GetFiremode and we:GetFiremode() then
			--draw.RoundedBoxEx( (c*16), w - (c*64), h - (c*44) - (c*14), (c*64), (c*14), CLR_B, true, false, false, false )
			local fmn = we:GetFiremodeTable(we:GetFiremode())
			if fmn.Count == 1 then
				fmn = "Semi-auto"--"Semi-auto"
			elseif fmn.Count == math.huge then
				fmn = "Full-auto"--"Automatic"
			else
				fmn = fmn.Count .. "-burst"--fmn.Count .. "-round burst"
			end
			ATTT_TextS( fmn, "ATTT_Bahnschrift_8", w - (c*90), h - (c*23.5), CLR_W, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		end
		ATTT_RectS( w - ow - (c*100), h - oh - (c*7), (c*100), (c*7), (c*1.5), CLR_W )
		surface.SetDrawColor( CLR_W )
		local meth = math.Clamp(we:Clip1()/we:GetMaxClip1(), 0, 1)
		surface.DrawRect( w - ow + ((1-meth)*c*100) - (c*100), h - oh - (c*7), (c*100) * meth, (c*7) )

		ATTT_TextS( we:Clip1(), "ATTT_Bahnschrift_24", w - (c*16), h - (c*8) - (c*9), CLR_W, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
		local bow = surface.GetTextSize(we:Clip1())
		ATTT_TextS( we:Ammo1(), "ATTT_Bahnschrift_12", w - (c*29) - bow, h - (c*8) - (c*13.9), CLR_W, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
		ATTT_TextS( "/", "ATTT_Bahnschrift_12", w - (c*21) - bow, h - (c*8) - (c*14.1), CLR_W, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )

	end
end

-- Radar, disguised, DNA
local MAX_CHARGE = 1250
local function ATTT_HUD_Extras(p)
	local c = ScreenScale(1)
	local y = (c*10)
	local w, h = ScrW(), ScrH()

	if p:GetNWBool("disguised", false) then
		ATTT_TextS( "Disguise enabled! Your name is hidden.", "ATTT_Bahnschrift_8", w/2, h - y, CLR_W, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		y = y + (c*10)
	end

	local radar = (wrapradar and wrapradar.enable and p:IsActiveSpecial())
	if radar then
		local remaining = math.max(0, wrapradar.endtime - CurTime())
		ATTT_TextS( "Radar ready in " .. util.SimpleTime(remaining, "%01i:%02i"), "ATTT_Bahnschrift_8", w/2, h - y, CLR_W, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		y = y + (c*10)
	end

	local tester = p:GetWeapon("weapon_ttt_wtester")
	if !IsValid(tester) then tester = false end
	if tester then
		--math.min(MAX_CHARGE, tester:GetCharge())
		ATTT_TextS( "DNA: " .. math.Round(tester:GetCharge()/1250*100) .. "%", "ATTT_Bahnschrift_8", w/2, h - y, CLR_W, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		y = y + (c*10)
	end
end

-- Paints player status HUD element in the bottom left
function GM:HUDPaint()
   local client = LocalPlayer()

   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTTargetID" ) then
       hook.Call( "HUDDrawTargetID", GAMEMODE )
   end
   
   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTMStack" ) then
       MSTACK:Draw(client)
   end

   if (not client:Alive()) or client:Team() == TEAM_SPEC then
      if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTSpecHUD" ) then
          SpecHUDPaint(client)
      end

      return
   end

   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTRadar" ) then
       RADAR:Draw(client)
   end
   
   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTTButton" ) then
       TBHUD:Draw(client)
   end
   
   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTWSwitch" ) then
       WSWITCH:Draw(client)
   end

   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTVoice" ) then
       VOICE.Draw(client)
   end
   
   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTDisguise" ) then
       DISGUISE.Draw(client)
   end

   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTPickupHistory" ) then
       hook.Call( "HUDDrawPickupHistory", GAMEMODE )
   end

   -- Draw bottom left info panel
   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTInfoPanel" ) then
       -- InfoPaint(client)
	   ATTT_HUD(client)
   end

	-- Fesiug's extras
	do
		ATTT_HUD_Extras(client)
	end
end

-- Hide the standard HUD stuff
local hud = {["CHudHealth"] = true, ["CHudBattery"] = true, ["CHudAmmo"] = true, ["CHudSecondaryAmmo"] = true}
function GM:HUDShouldDraw(name)
   if hud[name] then return false end

   return self.BaseClass.HUDShouldDraw(self, name)
end

