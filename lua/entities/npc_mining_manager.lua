
AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.Spawnable = false

if SERVER then
	util.AddNetworkString( "OpenMiningUpgradeMenu" )
end

function ENT:Initialize()

	--self:SetModel( "models/props_halloween/ghost_no_hat.mdl" )
	--self:SetModel( "models/props_wasteland/controlroom_filecabinet002a.mdl" )
	self:SetModel( "models/humans/group03/male_07.mdl" )
	
	if SERVER then
		self.Entity:SetUseType(SIMPLE_USE)
	
		self.Hat = ents.Create( "prop_physics" )
			self.Hat:SetModel( "models/props_2fort/hardhat001.mdl" )
			self.Hat:SetOwner( self )
			self.Hat:SetMoveType( MOVETYPE_NONE )
			self.Hat:SetParent( self, 4 )
			self.Hat:SetPos( self:GetAttachment(4).Pos - self:GetForward() * 1.5 + self:GetUp() )
			self.Hat:SetAngles( self:GetAngles() + Angle(20,180,0) )
			self.Hat:SetModelScale( 0.75 )
			
		self:CallOnRemove( "DeleteMiningHat", function(ent) 
			if IsValid(ent.Hat) then
				local leftover = ents.Create( "prop_physics" )
					leftover:SetModel( "models/props_2fort/hardhat001.mdl" )
					leftover:SetPos( ent.Hat:GetPos() )
					leftover:SetAngles( ent.Hat:GetAngles() )
					leftover:PhysicsInit( SOLID_VPHYSICS )
					leftover:SetMoveType( MOVETYPE_VPHYSICS )
					leftover:SetSolid( SOLID_VPHYSICS )
					leftover:GetPhysicsObject():Wake()
				timer.Simple( 20, function() if IsValid(leftover) then leftover:Remove() end end )
				ent.Hat:Remove() 
			end 
		end )
	end
end

function ENT:RunBehaviour()

	while ( true ) do

		self:StartActivity( ACT_WALK ) -- walk anims
		self.loco:SetDesiredSpeed( 100 ) -- walk speeds

		-- Choose a random location within 400 units of our position
		local targetPos = self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 200

		-- Search for walkable space there, or nearby
		local area = navmesh.GetNearestNavArea( targetPos )

		-- We found walkable space, get the closest point on that area to where we want to be
		if ( IsValid( area ) ) then 
			targetPos = area:GetClosestPointOnArea( targetPos )
			self:MoveToPos( targetPos ) 
		end

		-- walk to the target place (yielding)
		
		self:StartActivity( ACT_IDLE )

		coroutine.wait( math.random(10,60) ) -- play a scene and wait for it to finish before 

		coroutine.yield()

	end

end

local greetings = {
	"scenes/npc/male01/hi01.vcd",
	"scenes/npc/male01/hi02.vcd",
	"scenes/npc/male01/heydoc01.vcd",
	"scenes/npc/male01/heydoc02.vcd",
	"scenes/npc/male01/excuseme01.vcd",
	"scenes/npc/male01/excuseme02.vcd"
}
function ENT:Use(activator, caller)
	
	if (activator:IsPlayer()) then
		self:PlayScene( greetings[math.random(table.Count(greetings))] )
		
		net.Start( "OpenMiningUpgradeMenu" )
		net.Send( activator )
	end
end

---------------------------------------------------------------------------------------------------------

if CLIENT then

local CostMult = 0.2

net.Receive( "OpenMiningUpgradeMenu", function( len, ply )
	
	if LocalPlayer().MiningManagerWindow then
		if LocalPlayer().MiningManagerWindow.Close then
			LocalPlayer().MiningManagerWindow:Close()
			LocalPlayer().MiningManagerWindow = nil
		end
	end
	LocalPlayer().MiningManagerWindow = vgui.Create("DFrame")
		LocalPlayer().MiningManagerWindow:SetPos(ScrW() / 2 - 304, ScrH() / 2 - 190)
		LocalPlayer().MiningManagerWindow:SetSize(608, 420)
		LocalPlayer().MiningManagerWindow:SetTitle("Mining Manager")
		LocalPlayer().MiningManagerWindow:ShowCloseButton(true)
		LocalPlayer().MiningManagerWindow:MakePopup()
		LocalPlayer().MiningManagerWindow:SetDraggable(true)
	---------------------------------------------------------------------------
	local Sell = vgui.Create("DFrame", LocalPlayer().MiningManagerWindow)
		Sell:SetPos(25, 25)
		Sell:SetSize(254+12.5, 370)
		Sell:SetTitle("Sell")
		Sell:ShowCloseButton(false)
		Sell:SetDraggable(false)
		Sell:SetIsMenu(true)
		
	local CopperLabelBg = vgui.Create("DImage", Sell)
		CopperLabelBg:SetPos( 10, 30 + 30 )
		CopperLabelBg:SetSize( 160, 25 )
		CopperLabelBg:SetImage( "models/shiny" )
	local CopperLabel = vgui.Create("DLabel", Sell)
		CopperLabel:SetPos( 20, 35 )
		CopperLabel:SetText( "Copper" )
		CopperLabel:SetSize( 130, 15 )
		CopperLabel:SetColor( Color(255,255,255,255) )
	local CopperAmount = vgui.Create("DLabel", Sell)
		CopperAmount:SetPos( 20, 35 + 30 )
		CopperAmount:SetText( "" .. LocalPlayer():GetNWInt("sboxmoneyminingcopper", 0) )
		CopperAmount:SetSize( 130, 15 )
		CopperAmount:SetColor( Color(0,0,0,255) )
	local CopperWorth = vgui.Create("DLabel", Sell)
		CopperWorth:SetPos( 110, 35 + 30 )
		CopperWorth:SetText( "(+" .. (LocalPlayer():GetNWInt("sboxmoneyminingcopper", 0) * 5) .. ")" )
		CopperWorth:SetSize( 130, 15 )
		CopperWorth:SetColor( Color(0,127,0,255) )
	local CopperSellAll = vgui.Create("DButton", Sell)
		CopperSellAll:SetPos(190, 30 + 30)
		CopperSellAll:SetSize(50, 25)
		CopperSellAll:SetText("Sell All")
		CopperSellAll.DoClick = function()
			net.Start( "SellMiningUpgradeMenu" )
				net.WriteInt( 0, 4 )
			net.SendToServer()
		end
		
	local SilverLabelBg = vgui.Create("DImage", Sell)
		SilverLabelBg:SetPos( 10, 30 + 90 )
		SilverLabelBg:SetSize( 160, 25 )
		SilverLabelBg:SetImage( "models/shiny" )
	local SilverLabel = vgui.Create("DLabel", Sell)
		SilverLabel:SetPos( 20, 35 + 60 )
		SilverLabel:SetText( "Silver" )
		SilverLabel:SetSize( 130, 15 )
		SilverLabel:SetColor( Color(255,255,255,255) )
	local SilverAmount = vgui.Create("DLabel", Sell)
		SilverAmount:SetPos( 20, 35 + 90 )
		SilverAmount:SetText( "" .. LocalPlayer():GetNWInt("sboxmoneyminingsilver", 0) )
		SilverAmount:SetSize( 130, 15 )
		SilverAmount:SetColor( Color(0,0,0,255) )
	local SilverWorth = vgui.Create("DLabel", Sell)
		SilverWorth:SetPos( 110, 35 + 90 )
		SilverWorth:SetText( "(+" .. (LocalPlayer():GetNWInt("sboxmoneyminingsilver", 0) * 10) .. ")" )
		SilverWorth:SetSize( 130, 15 )
		SilverWorth:SetColor( Color(0,127,0,255) )
	local SilverSellAll = vgui.Create("DButton", Sell)
		SilverSellAll:SetPos(190, 30 + 90)
		SilverSellAll:SetSize(50, 25)
		SilverSellAll:SetText("Sell All")
		SilverSellAll.DoClick = function()
			net.Start( "SellMiningUpgradeMenu" )
				net.WriteInt( 1, 4 )
			net.SendToServer()
		end
		
	local GoldLabelBg = vgui.Create("DImage", Sell)
		GoldLabelBg:SetPos( 10, 30 + 150 )
		GoldLabelBg:SetSize( 160, 25 )
		GoldLabelBg:SetImage( "models/shiny" )
	local GoldLabel = vgui.Create("DLabel", Sell)
		GoldLabel:SetPos( 20, 35 + 120 )
		GoldLabel:SetText( "Gold" )
		GoldLabel:SetSize( 130, 15 )
		GoldLabel:SetColor( Color(255,255,255,255) )
	local GoldAmount = vgui.Create("DLabel", Sell)
		GoldAmount:SetPos( 20, 35 + 150 )
		GoldAmount:SetText( "" .. LocalPlayer():GetNWInt("sboxmoneymininggold", 0) )
		GoldAmount:SetSize( 130, 15 )
		GoldAmount:SetColor( Color(0,0,0,255) )
	local GoldWorth = vgui.Create("DLabel", Sell)
		GoldWorth:SetPos( 110, 35 + 150 )
		GoldWorth:SetText( "(+" .. (LocalPlayer():GetNWInt("sboxmoneymininggold", 0) * 30) .. ")" )
		GoldWorth:SetSize( 130, 15 )
		GoldWorth:SetColor( Color(0,127,0,255) )
	local GoldSellAll = vgui.Create("DButton", Sell)
		GoldSellAll:SetPos(190, 30 + 150)
		GoldSellAll:SetSize(50, 25)
		GoldSellAll:SetText("Sell All")
		GoldSellAll.DoClick = function()
			net.Start( "SellMiningUpgradeMenu" )
				net.WriteInt( 2, 4 )
			net.SendToServer()
		end
		
	local PlatinumLabelBg = vgui.Create("DImage", Sell)
		PlatinumLabelBg:SetPos( 10, 30 + 210 )
		PlatinumLabelBg:SetSize( 160, 25 )
		PlatinumLabelBg:SetImage( "models/shiny" )
	local PlatinumLabel = vgui.Create("DLabel", Sell)
		PlatinumLabel:SetPos( 20, 35 + 180 )
		PlatinumLabel:SetText( "Platinum" )
		PlatinumLabel:SetSize( 130, 15 )
		PlatinumLabel:SetColor( Color(255,255,255,255) )
	local PlatinumAmount = vgui.Create("DLabel", Sell)
		PlatinumAmount:SetPos( 20, 35 + 210 )
		PlatinumAmount:SetText( "" .. LocalPlayer():GetNWInt("sboxmoneyminingplatinum", 0) )
		PlatinumAmount:SetSize( 130, 15 )
		PlatinumAmount:SetColor( Color(0,0,0,255) )
	local PlatinumWorth = vgui.Create("DLabel", Sell)
		PlatinumWorth:SetPos( 110, 35 + 210 )
		PlatinumWorth:SetText( "(+" .. (LocalPlayer():GetNWInt("sboxmoneyminingplatinum", 0) * 30) .. ")" )
		PlatinumWorth:SetSize( 130, 15 )
		PlatinumWorth:SetColor( Color(0,127,0,255) )
	local PlatinumSellAll = vgui.Create("DButton", Sell)
		PlatinumSellAll:SetPos(190, 30 + 210)
		PlatinumSellAll:SetSize(50, 25)
		PlatinumSellAll:SetText("Sell All")
		PlatinumSellAll.DoClick = function()
			net.Start( "SellMiningUpgradeMenu" )
				net.WriteInt( 3, 4 )
			net.SendToServer()
		end
		
	local SellAll = vgui.Create("DButton", Sell)
		SellAll:SetPos(25, 30 + 300)
		SellAll:SetSize(210, 25)
		SellAll:SetText("Sell Everything")
		SellAll.DoClick = function()
			net.Start( "SellMiningUpgradeMenu" )
				net.WriteInt( -1, 4 )
			net.SendToServer()
		end
		
	---------------------------------------------------------------------------
	local Upgrade = vgui.Create("DFrame", LocalPlayer().MiningManagerWindow)
		Upgrade:SetPos(25+279+12.5, 25)
		Upgrade:SetSize(254+12.5, 370)
		Upgrade:SetTitle("Upgrade Pickaxe")
		Upgrade:ShowCloseButton(false)
		Upgrade:SetDraggable(false)
		Upgrade:SetIsMenu(true)
		
	local UpgradeSpeedBg = vgui.Create("DImage", Upgrade)
		UpgradeSpeedBg:SetPos( 10, 30 + 30 )
		UpgradeSpeedBg:SetSize( 160, 25 )
		UpgradeSpeedBg:SetImage( "models/shiny" )
	local UpgradeSpeedLabel = vgui.Create("DLabel", Upgrade)
		UpgradeSpeedLabel:SetPos( 20, 35 )
		UpgradeSpeedLabel:SetText( "Swing Speed (" ..LocalPlayer():GetNWInt("sboxmoneyminingspeed", 0).. ")" )
		UpgradeSpeedLabel:SetSize( 130, 15 )
		UpgradeSpeedLabel:SetColor( Color(255,255,255,255) )
	local UpgradeSpeedText = vgui.Create("DLabel", Upgrade)
		UpgradeSpeedText:SetPos( 20, 35 + 30 )
		UpgradeSpeedText:SetText( (0.6 - LocalPlayer():GetNWInt("sboxmoneyminingspeed", 0) * 0.008) .. "s - 0.008s" )
		UpgradeSpeedText:SetSize( 130, 15 )
		UpgradeSpeedText:SetColor( Color(0,0,0,255) )
	local UpgradeSpeedCost = vgui.Create("DLabel", Upgrade)
		UpgradeSpeedCost:SetPos( 130, 35 + 30 )
		UpgradeSpeedCost:SetText( "(-" .. ((LocalPlayer():GetNWInt("sboxmoneyminingspeed", 0) + 1) * 200 * CostMult) .. ")" )
		UpgradeSpeedCost:SetSize( 130, 15 )
		UpgradeSpeedCost:SetColor( Color(255,0,0,255) )
	local UpgradeSpeedButton = vgui.Create("DButton", Upgrade)
		UpgradeSpeedButton:SetPos(190, 30 + 30)
		UpgradeSpeedButton:SetSize(50, 25)
		UpgradeSpeedButton:SetText("Upgrade")
		UpgradeSpeedButton.DoClick = function()
			if LocalPlayer():GetNWFloat( "sboxmoneyamount" ) < (LocalPlayer():GetNWInt("sboxmoneyminingspeed", 0) + 1) * 200 * CostMult then return end
			if tonumber(LocalPlayer():GetNWInt( "sboxmoneyminingspeed", 0 )) > 50 then return end
			
			net.Start( "UpgradeMiningUpgradeMenu" )
				net.WriteInt( 0, 4 )
				net.WriteFloat( (LocalPlayer():GetNWInt("sboxmoneyminingspeed", 0) + 1) * 200 * CostMult )
			net.SendToServer()
		end
		
	local UpgradeRangeBg = vgui.Create("DImage", Upgrade)
		UpgradeRangeBg:SetPos( 10, 30 + 90 )
		UpgradeRangeBg:SetSize( 160, 25 )
		UpgradeRangeBg:SetImage( "models/shiny" )
	local UpgradeRangeLabel = vgui.Create("DLabel", Upgrade)
		UpgradeRangeLabel:SetPos( 20, 35 + 60 )
		UpgradeRangeLabel:SetText( "Swing Range (" ..LocalPlayer():GetNWInt("sboxmoneyminingrange", 0).. ")"  )
		UpgradeRangeLabel:SetSize( 130, 15 )
		UpgradeRangeLabel:SetColor( Color(255,255,255,255) )
	local UpgradeRangeText = vgui.Create("DLabel", Upgrade)
		UpgradeRangeText:SetPos( 20, 35 + 90 )
		UpgradeRangeText:SetText( (60 + LocalPlayer():GetNWInt("sboxmoneyminingrange", 0) * 1.8) .. "hu + 1.8hu" )
		UpgradeRangeText:SetSize( 130, 15 )
		UpgradeRangeText:SetColor( Color(0,0,0,255) )
	local UpgradeRangeCost = vgui.Create("DLabel", Upgrade)
		UpgradeRangeCost:SetPos( 130, 35 + 90 )
		UpgradeRangeCost:SetText( "(-" .. ((LocalPlayer():GetNWInt("sboxmoneyminingrange", 0) + 1) * 160 * CostMult) .. ")" )
		UpgradeRangeCost:SetSize( 130, 15 )
		UpgradeRangeCost:SetColor( Color(255,0,0,255) )
	local UpgradeRangeButton = vgui.Create("DButton", Upgrade)
		UpgradeRangeButton:SetPos(190, 30 + 90)
		UpgradeRangeButton:SetSize(50, 25)
		UpgradeRangeButton:SetText("Upgrade")
		UpgradeRangeButton.DoClick = function()
			if LocalPlayer():GetNWFloat( "sboxmoneyamount" ) < (LocalPlayer():GetNWInt("sboxmoneyminingrange", 0) + 1) * 160 * CostMult then return end
			if tonumber(LocalPlayer():GetNWInt( "sboxmoneyminingrange", 0 )) > 50 then return end
			
			net.Start( "UpgradeMiningUpgradeMenu" )
				net.WriteInt( 1, 4 )
				net.WriteFloat( (LocalPlayer():GetNWInt("sboxmoneyminingrange", 0) + 1) * 160 * CostMult )
			net.SendToServer()
		end
		
	local UpgradeBonusOreBg = vgui.Create("DImage", Upgrade)
		UpgradeBonusOreBg:SetPos( 10, 30 + 150 )
		UpgradeBonusOreBg:SetSize( 160, 25 )
		UpgradeBonusOreBg:SetImage( "models/shiny" )
	local UpgradeBonusOreLabel = vgui.Create("DLabel", Upgrade)
		UpgradeBonusOreLabel:SetPos( 20, 35 + 120 )
		UpgradeBonusOreLabel:SetText( "Bonus Ore Chance (" ..LocalPlayer():GetNWInt("sboxmoneyminingbonus", 0).. ")" )
		UpgradeBonusOreLabel:SetSize( 130, 15 )
		UpgradeBonusOreLabel:SetColor( Color(255,255,255,255) )
	local UpgradeBonusOreText = vgui.Create("DLabel", Upgrade)
		UpgradeBonusOreText:SetPos( 20, 35 + 150 )
		UpgradeBonusOreText:SetText( (0 + LocalPlayer():GetNWInt("sboxmoneyminingbonus", 0) * 7.5) .. "% + 7.5%" )
		UpgradeBonusOreText:SetSize( 130, 15 )
		UpgradeBonusOreText:SetColor( Color(0,0,0,255) )
	local UpgradeBonusOreCost = vgui.Create("DLabel", Upgrade)
		UpgradeBonusOreCost:SetPos( 130, 35 + 150 )
		UpgradeBonusOreCost:SetText( "(-" .. ((LocalPlayer():GetNWInt("sboxmoneyminingbonus", 0) + 1) * 500 * CostMult) .. ")" )
		UpgradeBonusOreCost:SetSize( 130, 15 )
		UpgradeBonusOreCost:SetColor( Color(255,0,0,255) )
	local UpgradeBonusOreButton = vgui.Create("DButton", Upgrade)
		UpgradeBonusOreButton:SetPos(190, 30 + 150)
		UpgradeBonusOreButton:SetSize(50, 25)
		UpgradeBonusOreButton:SetText("Upgrade")
		UpgradeBonusOreButton.DoClick = function()
			if LocalPlayer():GetNWFloat( "sboxmoneyamount" ) < (LocalPlayer():GetNWInt("sboxmoneyminingbonus", 0) + 1) * 500 * CostMult then return end
			if tonumber(LocalPlayer():GetNWInt( "sboxmoneyminingbonus", 0 )) > 50 then return end
			
			net.Start( "UpgradeMiningUpgradeMenu" )
				net.WriteInt( 2, 4 )
				net.WriteFloat( (LocalPlayer():GetNWInt("sboxmoneyminingbonus", 0) + 1) * 500 * CostMult )
			net.SendToServer()
		end
		
	local UpgradePreciseCutBg = vgui.Create("DImage", Upgrade)
		UpgradePreciseCutBg:SetPos( 10, 30 + 210 )
		UpgradePreciseCutBg:SetSize( 160, 25 )
		UpgradePreciseCutBg:SetImage( "models/shiny" )
	local UpgradePreciseCutLabel = vgui.Create("DLabel", Upgrade)
		UpgradePreciseCutLabel:SetPos( 20, 35 + 180 )
		UpgradePreciseCutLabel:SetText( "Precise Cut Chance (" ..LocalPlayer():GetNWInt("sboxmoneyminingprecise", 0).. ")" )
		UpgradePreciseCutLabel:SetSize( 130, 15 )
		UpgradePreciseCutLabel:SetColor( Color(255,255,255,255) )
	local UpgradePreciseCutText = vgui.Create("DLabel", Upgrade)
		UpgradePreciseCutText:SetPos( 20, 35 + 210 )
		UpgradePreciseCutText:SetText( (0 + LocalPlayer():GetNWInt("sboxmoneyminingprecise", 0) * 1.5) .. "% + 1.5%" )
		UpgradePreciseCutText:SetSize( 130, 15 )
		UpgradePreciseCutText:SetColor( Color(0,0,0,255) )
	local UpgradePreciseCutCost = vgui.Create("DLabel", Upgrade)
		UpgradePreciseCutCost:SetPos( 130, 35 + 210 )
		UpgradePreciseCutCost:SetText( "(-" .. ((LocalPlayer():GetNWInt("sboxmoneyminingprecise", 0) + 1) * 400 * CostMult) .. ")" )
		UpgradePreciseCutCost:SetSize( 130, 15 )
		UpgradePreciseCutCost:SetColor( Color(255,0,0,255) )
	local UpgradePreciseCutButton = vgui.Create("DButton", Upgrade)
		UpgradePreciseCutButton:SetPos(190, 30 + 210)
		UpgradePreciseCutButton:SetSize(50, 25)
		UpgradePreciseCutButton:SetText("Upgrade")
		UpgradePreciseCutButton.DoClick = function()
			if LocalPlayer():GetNWFloat( "sboxmoneyamount" ) < (LocalPlayer():GetNWInt("sboxmoneyminingprecise", 0) + 1) * 400 * CostMult then return end
			if tonumber(LocalPlayer():GetNWInt( "sboxmoneyminingprecise", 0 )) > 50 then return end
			
			net.Start( "UpgradeMiningUpgradeMenu" )
				net.WriteInt( 3, 4 )
				net.WriteFloat( (LocalPlayer():GetNWInt("sboxmoneyminingprecise", 0) + 1) * 400 * CostMult )
			net.SendToServer()
		end
		
	local UpgradeMagicOreBg = vgui.Create("DImage", Upgrade)
		UpgradeMagicOreBg:SetPos( 10, 30 + 270 )
		UpgradeMagicOreBg:SetSize( 160, 25 )
		UpgradeMagicOreBg:SetImage( "models/shiny" )
	local UpgradeMagicOreLabel = vgui.Create("DLabel", Upgrade)
		UpgradeMagicOreLabel:SetPos( 20, 35 + 240 )
		UpgradeMagicOreLabel:SetText( "Magic Ore Chance (" ..LocalPlayer():GetNWInt("sboxmoneyminingmagic", 0).. ")" )
		UpgradeMagicOreLabel:SetSize( 130, 15 )
		UpgradeMagicOreLabel:SetColor( Color(255,255,255,255) )
	local UpgradeMagicOreText = vgui.Create("DLabel", Upgrade)
		UpgradeMagicOreText:SetPos( 20, 35 + 270 )
		UpgradeMagicOreText:SetText( (0 + LocalPlayer():GetNWInt("sboxmoneyminingmagic", 0) * 0.5) .. "% + 0.5%" )
		UpgradeMagicOreText:SetSize( 130, 15 )
		UpgradeMagicOreText:SetColor( Color(0,0,0,255) )
	local UpgradeMagicOreCost = vgui.Create("DLabel", Upgrade)
		UpgradeMagicOreCost:SetPos( 130, 35 + 270 )
		UpgradeMagicOreCost:SetText( "(-" .. ((LocalPlayer():GetNWInt("sboxmoneyminingmagic", 0) + 1) * 600 * CostMult) .. ")" )
		UpgradeMagicOreCost:SetSize( 130, 15 )
		UpgradeMagicOreCost:SetColor( Color(255,0,0,255) )
	local UpgradeMagicOreButton = vgui.Create("DButton", Upgrade)
		UpgradeMagicOreButton:SetPos(190, 30 + 270)
		UpgradeMagicOreButton:SetSize(50, 25)
		UpgradeMagicOreButton:SetText("Upgrade")
		UpgradeMagicOreButton.DoClick = function()
			if LocalPlayer():GetNWFloat( "sboxmoneyamount" ) < (LocalPlayer():GetNWInt("sboxmoneyminingmagic", 0) + 1) * 600 * CostMult then return end
			if tonumber(LocalPlayer():GetNWInt( "sboxmoneyminingmagic", 0 )) > 50 then return end
			
			net.Start( "UpgradeMiningUpgradeMenu" )
				net.WriteInt( 4, 4 )
				net.WriteFloat( (LocalPlayer():GetNWInt("sboxmoneyminingmagic", 0) + 1) * 600 * CostMult )
			net.SendToServer()
		end
end )

end

--
-- List the NPC as spawnable
--
list.Set( "NPC", "npc_mining_manager", {
	Name = "Mining Manager",
	Class = "npc_mining_manager",
	Category = "Epic Sandbox Systems"
} )
