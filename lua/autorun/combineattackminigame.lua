COMBINEATTACKMINIGAME = {}
COMBINEATTACKMINIGAME.Attackers = {}

local function LoadFonts() 
	if CLIENT then
		surface.CreateFont( "CombineAttackMinigameLevelFont", {
			font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
			extended = false,
			size = 70,
			weight = 500,
			blursize = 0,
			scanlines = 0,
			antialias = true,
			underline = false,
			italic = false,
			strikeout = false,
			symbol = false,
			rotary = false,
			shadow = false,
			additive = false,
			outline = false,
		} )
	end
end

local startRadioSounds = {
	"npc/metropolice/vo/isathardpointreadytoprosecute.wav",
	"npc/metropolice/vo/11-99officerneedsassistance.wav",
	"npc/metropolice/vo/contactwith243suspect.wav",
	"npc/metropolice/vo/isathardpointreadytoprosecute.wav",
	"npc/metropolice/vo/priority2anticitizenhere.wav",
	"npc/metropolice/vo/readytoprosecutefinalwarning.wav"
}

local combatMusic = {
	"music/hl2_song12_long.mp3",
	"music/hl2_song16.mp3",
	"music/hl2_song15.mp3",
	"music/hl2_song14.mp3",
	"music/hl2_song20_submix4.mp3",
	"music/hl2_song29.mp3",
	"music/hl2_song4.mp3",
}

local CombineAttackLevel = {}
CombineAttackLevel["5"] = {
	"npc_metropolice"
}
CombineAttackLevel["10"] = {
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_combine_s",
	"npc_combine_s",
}
CombineAttackLevel["15"] = {
	"npc_metropolice",
	"npc_combine_s",
	"npc_combine_s",
}
CombineAttackLevel["20"] = {
	"npc_combine_s",
}
CombineAttackLevel["25"] = {
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"CombineElite",
}
CombineAttackLevel["30"] = {
	"npc_combine_s",
	"npc_combine_s",
	"CombineElite",
}
CombineAttackLevel["35"] = {
	"npc_combine_s",
	"CombineElite",
}
CombineAttackLevel["40"] = {
	"npc_combine_s",
	"npc_combine_s",
	"CombineElite",
	"CombineElite",
	"npc_hlvr_suppressor_s",
}
CombineAttackLevel["45"] = {
	"npc_combine_s",
	"CombineElite",
	"CombineElite",
	"CombineElite",
	"npc_hlvr_suppressor_s",
}
CombineAttackLevel["50"] = {
	"CombineElite",
	"CombineElite",
	"npc_hlvr_suppressor_s",
}
local CombineAttackLevelWeapons = {}
CombineAttackLevelWeapons["5"] = {
	"weapon_stunstick",
	"weapon_stunstick",
	"weapon_pistol",
}
CombineAttackLevelWeapons["10"] = {
	"weapon_pistol",
}
CombineAttackLevelWeapons["15"] = {
	"weapon_pistol",
	"weapon_smg1",
}
CombineAttackLevelWeapons["20"] = {
	"weapon_smg1",
}
CombineAttackLevelWeapons["25"] = {
	"weapon_smg1",
	"weapon_smg1",
	"weapon_ar2",
}
CombineAttackLevelWeapons["30"] = {
	"weapon_smg1",
	"weapon_ar2",
}
CombineAttackLevelWeapons["35"] = {
	"weapon_smg1",
	"weapon_ar2",
}
CombineAttackLevelWeapons["40"] = {
	"weapon_smg1",
	"weapon_ar2",
	"weapon_shotgun",
}
CombineAttackLevelWeapons["45"] = {
	"weapon_ar2",
	"weapon_shotgun",
}
CombineAttackLevelWeapons["50"] = {
	"weapon_ar2",
	"weapon_shotgun",
}

hook.Add( "Initialize", "CombineAttackMinigameLoadFonts", function()
	LoadFonts()
end )

hook.Add( "OnNPCKilled", "StartCombineAttackMinigame", function(npc, attacker, inflictor)
	if !IsValid(attacker) or !attacker:IsPlayer() then return end
	
	if npc:GetNWBool( "combineattackminigame", false ) and attacker:GetNWInt( "CombineAttackMinigameLevel", 0 ) > 0 then
		for i=1,table.Count(attacker.combineattackenemies) do
			if attacker.combineattackenemies[i] == npc:EntIndex() then
				table.remove( attacker.combineattackenemies, i )
				attacker:SetNWInt( "CombineAttackMinigameScore", attacker:GetNWInt( "CombineAttackMinigameScore", 0 ) + npc:GetMaxHealth() )
				local score = attacker:GetNWInt( "CombineAttackMinigameScore", 0 ) / 25
				local levelup = attacker:GetNWInt( "CombineAttackMinigameLevel", 1 ) < math.floor(1 + -1.5+math.sqrt(9+4*score)/2)
				attacker:SetNWInt( "CombineAttackMinigameLevel", math.floor(1 + -1.5+math.sqrt(9+4*score)/2) ) -- See crudely drawn image for details
				net.Start( "UpdateCombineAttackMinigameMenu" )
					net.WriteInt( attacker:GetNWInt( "CombineAttackMinigameLevel", 1 ), 12 )
					net.WriteInt( attacker:GetNWInt( "CombineAttackMinigameScore", 0 ), 32 )
					net.WriteBool( levelup )
				net.Send( attacker )
			end
		end
	end
	
	if attacker:GetNWInt( "CombineAttackMinigameLevel", 0 ) > 0 then return end
	if npc:GetModel() ~= "models/hlvr/characters/combine/suppressor/combine_suppressor_hlvr_npc.mdl" then return end

	attacker:ChatPrint( "You are now wanted by the Universal Union..." )
	sound.Play( startRadioSounds[math.random(table.Count(startRadioSounds))], attacker:GetPos(), 100 )
	attacker:SetNWInt( "CombineAttackMinigameScore", 0 )
	attacker:SetNWInt( "CombineAttackMinigameLevel", 1 )
	table.insert( COMBINEATTACKMINIGAME.Attackers, attacker )
	net.Start( "UpdateCombineAttackMinigameMenu" )
		net.WriteInt( attacker:GetNWInt( "CombineAttackMinigameLevel", 1 ), 12 )
		net.WriteInt( attacker:GetNWInt( "CombineAttackMinigameScore", 0 ), 32 )
		net.WriteBool( true )
	net.Send( attacker )
end)

hook.Add( "PlayerDeath", "EndCombineAttackMinigame", function( victim, inflictor, attacker )
	
	if victim:GetNWInt("CombineAttackMinigameLevel", 0) == 0 then return end

	SANDBOXMONEY.SandboxMoneyAddCurrency( victim, victim:GetNWInt( "CombineAttackMinigameScore", 0 )/20+victim:GetNWInt( "CombineAttackMinigameLevel", 0 )*victim:GetNWInt( "CombineAttackMinigameLevel", 0 ) )
	
	
	net.Start( "UpdateCombineAttackMinigameMenu" )
		net.WriteInt( 0, 12 )
		net.WriteInt( 0, 32 )
		net.WriteBool( false )
	net.Send( victim )
	victim:SetNWInt( "CombineAttackMinigameLevel", 0 ) -- We're betting on this being slower than the net call
	victim:SetNWInt( "CombineAttackMinigameScore", 0 )
	for i=1,table.Count(COMBINEATTACKMINIGAME.Attackers) do
		if COMBINEATTACKMINIGAME.Attackers[i] == victim then
			table.remove( COMBINEATTACKMINIGAME.Attackers, i )
		end
	end
	for k, v in ipairs( ents.FindByName( "Combine Dispatch" ) ) do
		if v:GetNWInt( "combineattackminigametarget", -1 ) == victim:EntIndex() then
			v:EmitSound( "ambient/energy/weld2.wav" )
			local effectdata = EffectData()
				effectdata:SetOrigin( v:GetPos() )
				effectdata:SetMagnitude( 20 )
				effectdata:SetScale( 1 )
				effectdata:SetNormal( v:GetUp() )
				util.Effect( "ElectricSpark", effectdata )
			v:Remove()
		end
	end
	table.Empty( victim.combineattackenemies )
end )
hook.Add( "PlayerDisconnected", "EndCombineAttackMinigameDisconnect", function( ply )
	
	if ply:GetNWInt("CombineAttackMinigameLevel", 0) == 0 then return end
	
	ply:SetNWInt( "CombineAttackMinigameLevel", 0 )
	ply:SetNWInt( "CombineAttackMinigameScore", 0 )
	for i=1,table.Count(COMBINEATTACKMINIGAME.Attackers) do
		if COMBINEATTACKMINIGAME.Attackers[i] == ply then
			table.remove( COMBINEATTACKMINIGAME.Attackers, i )
		end
	end
	for k, v in ipairs( ents.FindByName( "Combine Dispatch" ) ) do
		if v:GetNWInt( "combineattackminigametarget", -1 ) == ply:EntIndex() then
			v:Remove()
		end
	end
	table.Empty( ply.combineattackenemies )
end )

----------------------------------------------------------------------------------------------------------

if SERVER then

util.AddNetworkString( "UpdateCombineAttackMinigameMenu" )
	
hook.Add( "PlayerInitialSpawn", "CombineAttackMinigameInitialSetup", function( ply )
	ply.combineattackenemies = {}
	ply.combineattackspawntime = 0
end )

local CombineAttackMinigameServerThinkTime = 0
hook.Add( "Think", "CombineAttackMinigameServerThink", function()
	for k, v in ipairs( COMBINEATTACKMINIGAME.Attackers ) do
		if v:GetNWInt( "CombineAttackMinigameLevel", 0 ) < 1 then return end
		if v.combineattackspawntime < CurTime() then
			v.combineattackspawntime = CurTime() + 2
			if table.Count( v.combineattackenemies ) > 30 then return end
			
			local targetPos = v:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 500 + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ):GetNormalized() * 500
			-- Search for walkable space there, or nearby
			local area = navmesh.GetNearestNavArea( targetPos )
			-- We found walkable space, get the closest point on that area to where we want to be
			if ( IsValid( area ) ) then targetPos = area:GetClosestPointOnArea( targetPos ) end
			local combineattackNPC = {}
			local level = math.min(math.ceil((v:GetNWInt( "CombineAttackMinigameLevel", 1 ) + 1) / 5) * 5,50)
			local class = CombineAttackLevel[""..level][math.random(table.Count(CombineAttackLevel[""..level]))] 
			local actualClass = ( (class == "CombineElite" or class == "npc_hlvr_suppressor_s") and "npc_combine_s" or class )
			combineattackNPC = ents.Create( actualClass ) 
			combineattackNPC:SetKeyValue( "additionalequipment", CombineAttackLevelWeapons[""..level][math.random(table.Count(CombineAttackLevelWeapons[""..level]))] )

			combineattackNPC:SetNWBool( "combineattackminigame", true )
			combineattackNPC:SetNWInt( "combineattackminigametarget", v:EntIndex() )
			combineattackNPC:SetName( "Combine Dispatch" )
			combineattackNPC:SetPos( targetPos )
			combineattackNPC:Spawn()			
			if class ~= actualClass then 
				combineattackNPC:SetMaxHealth( class == "CombineElite" and 70 or class == "npc_hlvr_suppressor_s" and 250 or 50 ) 
				combineattackNPC:SetHealth( class == "CombineElite" and 70 or class == "npc_hlvr_suppressor_s" and 250 or 50 ) 
				combineattackNPC:SetModel( class == "CombineElite" and "models/combine_super_soldier.mdl" or class == "npc_hlvr_suppressor_s" and "models/hlvr/characters/combine/suppressor/combine_suppressor_hlvr_npc.mdl" or "" )
			end
			combineattackNPC:AddRelationship( "player D_NU 98" )
			combineattackNPC:AddEntityRelationship(v, D_HT, 99 )
			local bits = bit.bor( SF_NPC_FADE_CORPSE, SF_NPC_NO_WEAPON_DROP )
			if math.random(100) < 20 then bits = bit.bor( bits, SF_NPC_DROP_HEALTHKIT ) end
			combineattackNPC:SetKeyValue( "spawnflags", bits )
			table.insert( v.combineattackenemies, combineattackNPC:EntIndex() )
			
			combineattackNPC:EmitSound( "ambient/energy/weld2.wav" )
			local effectdata = EffectData()
				effectdata:SetOrigin( combineattackNPC:GetPos() )
				effectdata:SetMagnitude( 20 )
				effectdata:SetScale( 1 )
				effectdata:SetNormal( combineattackNPC:GetUp() )
				util.Effect( "ElectricSpark", effectdata )
				
		end
	end
end )

end

----------------------------------------------------------------------------------------------------------

if CLIENT then

net.Receive( "UpdateCombineAttackMinigameMenu", function( len, ply )
	local level = net.ReadInt( 12 )
	local score = net.ReadInt( 32 )
	local levelup = net.ReadBool()
	
	if levelup then
		LocalPlayer():EmitSound( "ambient/alarms/warningbell1.wav" )
	end
	if levelup and ( level == 1 or math.fmod(level, 5) == 0 ) then
		if LocalPlayer().CombineAttackMusic then
			LocalPlayer().CombineAttackMusic:Stop()
			LocalPlayer().CombineAttackMusic = nil
		end
		LocalPlayer().CombineAttackMusic = CreateSound(LocalPlayer(),combatMusic[math.random(table.Count(combatMusic))])
		LocalPlayer().CombineAttackMusic:SetSoundLevel(75)
		timer.Simple(2, function()
			if not IsValid( LocalPlayer() ) then return end
			if not LocalPlayer():Alive() then return end
			LocalPlayer().CombineAttackMusic:Play()
		end )
	elseif level == 0 then
		if LocalPlayer().CombineAttackMusic then
			LocalPlayer().CombineAttackMusic:Stop()
			LocalPlayer().CombineAttackMusic = nil
		end
		local level = LocalPlayer():GetNWInt( "CombineAttackMinigameLevel", 0 )
		local score = LocalPlayer():GetNWInt( "CombineAttackMinigameScore", 0 )
		local ResultScreen = vgui.Create("DFrame")
			ResultScreen:SetSize(400, 200)
			ResultScreen:SetPos(ScrW() / 2 - 200, ScrH() / 2 - 100)
			ResultScreen:SetTitle("You finally died...")
			ResultScreen:ShowCloseButton(true)
			ResultScreen:SetDraggable(true)
			ResultScreen:MakePopup(true)
		local ResultScreenSize = {ResultScreen:GetSize()}
		local LevelResult = vgui.Create("DLabel", ResultScreen)
			LevelResult:SetFont( "Trebuchet24" )
			LevelResult:SetText( "RESULTS" )
			LevelResult:SizeToContents()
			LevelResult:SetPos( ResultScreenSize[1] / 2 - LevelResult:GetSize() / 2, 30 )
			LevelResult:SetColor( Color(255,255,255,255) )
		local LevelResult = vgui.Create("DLabel", ResultScreen)
			LevelResult:SetFont( "Default" )
			LevelResult:SetText( "LEVEL : " .. level )
			LevelResult:SizeToContents()
			LevelResult:SetPos( ResultScreenSize[1] / 2 - LevelResult:GetSize() / 2, 100 )
			LevelResult:SetColor( Color(255,255,255,255) )
		local ScoreResult = vgui.Create("DLabel", ResultScreen)
			ScoreResult:SetFont( "Default" )
			ScoreResult:SetText( "SCORE : " .. score )
			ScoreResult:SizeToContents()
			ScoreResult:SetPos( ResultScreenSize[1] / 2 - ScoreResult:GetSize() / 2, 120 )
			ScoreResult:SetColor( Color(255,255,255,255) )
		local MoneyResult = vgui.Create("DLabel", ResultScreen)
			MoneyResult:SetFont( "Default" )
			MoneyResult:SetText( (score/20+level*level) .. " COINS EARNED" )
			MoneyResult:SizeToContents()
			MoneyResult:SetPos( ResultScreenSize[1] / 2 - MoneyResult:GetSize() / 2, 160 )
			MoneyResult:SetColor( Color(255,255,255,255) )
	end
	
	if LocalPlayer().CombineAttackMinigameWindow then
		if LocalPlayer().CombineAttackMinigameWindow.Close then
			LocalPlayer().CombineAttackMinigameWindow:Close()
			LocalPlayer().CombineAttackMinigameWindow = nil
		end
	end
	if level <= 0 then return end
	
	LocalPlayer().CombineAttackMinigameWindow = vgui.Create("DFrame")
		LocalPlayer().CombineAttackMinigameWindow:SetPos(ScrW() / 2 - 200, 0)
		LocalPlayer().CombineAttackMinigameWindow:SetSize(400, 200)
		LocalPlayer().CombineAttackMinigameWindow:SetTitle("")
		LocalPlayer().CombineAttackMinigameWindow:ShowCloseButton(false)
		LocalPlayer().CombineAttackMinigameWindow:SetDraggable(false)
		LocalPlayer().CombineAttackMinigameWindow.Paint = function()
			if LocalPlayer().CombineAttackMinigameWindow and IsValid(LocalPlayer().CombineAttackMinigameWindow) then
				draw.RoundedBox(0, 0, 0, LocalPlayer().CombineAttackMinigameWindow:GetWide(), LocalPlayer().CombineAttackMinigameWindow:GetTall(), Color(0, 0, 0, 200))
			end
		end
	local MinigameWindowSize = {LocalPlayer().CombineAttackMinigameWindow:GetSize()}
	local TitleLabel = vgui.Create("DLabel", LocalPlayer().CombineAttackMinigameWindow)
		TitleLabel:SetFont( "Default" )
		TitleLabel:SetText( "COMBINE ATTACK" )
		TitleLabel:SizeToContents()
		TitleLabel:SetPos( MinigameWindowSize[1] / 2 - TitleLabel:GetSize() / 2, 10 )
		TitleLabel:SetColor( Color(255,255,255,255) )
		
	local LevelLabel = vgui.Create("DLabel", LocalPlayer().CombineAttackMinigameWindow)
		LevelLabel:SetFont( "CombineAttackMinigameLevelFont" )
		LevelLabel:SetText( "LEVEL " .. level )
		LevelLabel:SizeToContents()
		LevelLabel:SetPos( MinigameWindowSize[1] / 2 - LevelLabel:GetSize() / 2, 40 )
		LevelLabel:SetColor( Color(255,255,255,255) )
		
	local ScoreTitle = vgui.Create("DLabel", LocalPlayer().CombineAttackMinigameWindow)
		ScoreTitle:SetFont( "Default" )
		ScoreTitle:SetText( "Score : " .. score )
		ScoreTitle:SizeToContents()
		ScoreTitle:SetPos( 25, MinigameWindowSize[2] - 30 )
		ScoreTitle:SetColor( Color(255,255,255,255) )
end )
	
end

----------------------------------------------------------------------------------------------------------