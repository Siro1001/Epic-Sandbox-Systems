local CURRENCY_NAME = "Coin"

SANDBOXMONEY = {}

if SERVER then

util.AddNetworkString( "DropSandboxMoneyInventoryItem" )
util.AddNetworkString( "DisplaySandboxMoneyGain" )
	
hook.Add( "PlayerInitialSpawn", "SandboxMoneyInitialSetup", function( ply )
	file.CreateDir("sandboxmoney")
	if file.Exists("sandboxmoney/" .. ply:SteamID64() .. ".txt", "DATA") then
		local amount = file.Read("sandboxmoney/" .. ply:SteamID64() .. ".txt", "DATA")
		ply:SetNWFloat("sboxmoneyamount", tonumber(amount))
	else
		file.Write("sandboxmoney/" .. ply:SteamID64() .. ".txt", "0")
		ply:SetNWFloat("sboxmoneyamount", 0)
	end
end )

net.Receive( "DropSandboxMoneyInventoryItem", function( len, ply )
	local item = net.ReadString()
	local amount = net.ReadFloat()
	
	local ent = ""
	if item == CURRENCY_NAME then
		ent = "item_sandboxmoney"
		amount = math.min( amount, ply:GetNWFloat("sboxmoneyamount") )
		SANDBOXMONEY.SandboxMoneyAddCurrency( ply, -1 * amount )
	end
	local trace = ply:GetEyeTrace()
	local entity = ents.Create(ent)
		entity:SetPos(trace.HitPos + trace.HitNormal * 10)
		entity:SetOwner(self.Owner)
		entity:SetNWFloat( "value", amount )
		entity.Value = amount
		entity:Spawn()
		entity:Activate()
		
end )

function SANDBOXMONEY.SandboxMoneyAddCurrency( ply, amount )
	ply:SetNWFloat("sboxmoneyamount", math.max( ply:GetNWFloat("sboxmoneyamount") + amount, 0 ))
	file.Write("sandboxmoney/" .. ply:SteamID64() .. ".txt", ""..ply:GetNWFloat("sboxmoneyamount"))
	net.Start( "DisplaySandboxMoneyGain" )
		net.WriteFloat( amount )
	net.Send( ply )
end

end
		
--------------------------------------------------------------------------------------------------------

concommand.Add( "AddCurrencySelf", function( ply, cmd, args, str )
	if not ply:IsSuperAdmin() then return end
	if table.Count( args ) < 1 then return end
	if tonumber( args[1] ) == nil then return end
	
	if SERVER then
		SANDBOXMONEY.SandboxMoneyAddCurrency( ply, tonumber( args[1] ) )
	end
end )

--------------------------------------------------------------------------------------------------------

if CLIENT then

local coins_sp = Material("sprites/coins.png", "unlitgeneric smooth")
	
hook.Add("HUDPaint", "SandboxMoneyDisplay", function() 
	local text = "" .. math.floor(LocalPlayer():GetNWFloat("sboxmoneyamount")) .. " " .. CURRENCY_NAME .. "(s)"
	local font = "Default"
	draw.SimpleText(text, font, ScrW() - 50, ScrH() * 0.5, Color(255, 255, 255, 175), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	surface.SetMaterial(coins_sp)
	surface.SetDrawColor(255,255,255)
	surface.DrawTexturedRect(ScrW() - 50, ScrH() * 0.5 - 12, 32, 32)
	
	if LocalPlayer().DisplaySandboxMoneyGainTime then
		LocalPlayer().DisplaySandboxMoneyGainTime = (LocalPlayer().DisplaySandboxMoneyGainTime > 0 and LocalPlayer().DisplaySandboxMoneyGainTime - 1 or 0)
		local gaintext = (LocalPlayer().DisplaySandboxMoneyGainAmount >= 0 and "+" or "") .. math.floor( LocalPlayer().DisplaySandboxMoneyGainAmount )
		draw.SimpleText(gaintext, font, ScrW() - 50, ScrH() * 0.5 - 20 + LocalPlayer().DisplaySandboxMoneyGainTime / 255 * 10, Color(255, 255, 255, LocalPlayer().DisplaySandboxMoneyGainTime / 255 * 175), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
end )

net.Receive( "DisplaySandboxMoneyGain", function( len, ply )
	local amount = net.ReadFloat()
	LocalPlayer().DisplaySandboxMoneyGainAmount = amount
	LocalPlayer().DisplaySandboxMoneyGainTime = 255
end )

hook.Add("Think", "SandboxMoneyInventoryMenu", function() 
	if input.IsKeyDown( KEY_F3 ) and LocalPlayer().SandboxMoneyWindow == nil then
		LocalPlayer():SetNWString("sboxmoneyinvselected", "" )
		LocalPlayer().SandboxMoneyWindow = vgui.Create("DFrame")
		LocalPlayer().SandboxMoneyWindow:Center()
		LocalPlayer().SandboxMoneyWindow:SetSize(608, 380)
		LocalPlayer().SandboxMoneyWindow:SetTitle(" ")
		LocalPlayer().SandboxMoneyWindow:ShowCloseButton(false)
					
		local alph = 0
		LocalPlayer().SandboxMoneyWindow:MakePopup()
		LocalPlayer().SandboxMoneyWindow:SetDraggable(true)
		LocalPlayer().SandboxMoneyWindow.Paint = function()
			if LocalPlayer().SandboxMoneyWindow and IsValid(LocalPlayer().SandboxMoneyWindow) then
				if alph < 200 then alph = alph + 3 end
			
				local w = LocalPlayer().SandboxMoneyWindow:GetWide()
				local t = LocalPlayer().SandboxMoneyWindow:GetTall()
			
				draw.RoundedBox(0, 0, 0, w, t, Color(0, 0, 0, alph))
			end
		end
		
		local btn = vgui.Create("DButton", LocalPlayer().SandboxMoneyWindow)
		btn:SetPos(580, 10)
		btn:SetSize(20, 20)
		btn:SetColor(Color(0, 0, 0))
		btn:SetText("X")
		btn:SetFont("default")
		btn.DoClick = function()
			if LocalPlayer().SandboxMoneyWindow and IsValid(LocalPlayer().SandboxMoneyWindow) then 
				LocalPlayer().SandboxMoneyWindow:Close() 
				LocalPlayer():SetNWString("sboxmoneyinvselected", "" )
				LocalPlayer().SandboxMoneyWindow = nil 
			else 
				print("ERROR: Window invalid")
			end
		end
		
		local NameEntry = vgui.Create( "DLabel", LocalPlayer().SandboxMoneyWindow )
		NameEntry:SetPos( 15, 5 )
		NameEntry:SetSize( 100, 30 )
		NameEntry:SetTextColor(Color(255, 255, 255))
		NameEntry:SetFont( "Default" )
		NameEntry:SetText( "Inventory" )
		
		--------------------------------------------------------------------------
		
		local drop = vgui.Create("DButton", LocalPlayer().SandboxMoneyWindow)
		drop:SetPos(5, 150)
		drop:SetSize(150, 30)
		drop:SetColor(Color(0, 0, 0))
		drop:SetText("Drop Selected")
		drop:SetFont("default")
		drop.DoClick = function()
			if not LocalPlayer().SubWindow == nil then return end
			if LocalPlayer():GetNWString("sboxmoneyinvselected") == "" then return end
			LocalPlayer().SubWindow = vgui.Create("DFrame")
			LocalPlayer().SubWindow:Center()
			LocalPlayer().SubWindow:SetSize(200, 200)
			LocalPlayer().SubWindow:SetTitle("Select Amount")
			LocalPlayer().SubWindow:ShowCloseButton(true)
			LocalPlayer().SubWindow:MakePopup()
			LocalPlayer().SubWindow.Paint = function()
				if LocalPlayer().SubWindow and IsValid(LocalPlayer().SubWindow) then
					local w = LocalPlayer().SubWindow:GetWide()
					local t = LocalPlayer().SubWindow:GetTall()
				
					draw.RoundedBox(0, 0, 0, w, t, Color(0, 0, 0, 255))
				end
			end
			
			local NumberDropped = vgui.Create( "DNumberWang", LocalPlayer().SubWindow )
			NumberDropped:SetPos( 5, 30 )
			NumberDropped:SetSize( 100, 30 )
			NumberDropped:SetMin(0)
			NumberDropped:SetMax(999999999)
			NumberDropped.OnValueChanged = function(self)
				LocalPlayer():SetNWFloat("sboxmoneyinvtodrop", self:GetValue() )
			end
			
			local ToDrop = vgui.Create("DButton", LocalPlayer().SubWindow)
			ToDrop:SetPos(5, 70)
			ToDrop:SetSize(100, 30)
			ToDrop:SetColor(Color(0, 0, 0))
			ToDrop:SetText("Drop")
			ToDrop:SetFont("default")
			ToDrop.DoClick = function()
				net.Start( "DropSandboxMoneyInventoryItem" )
					net.WriteString( LocalPlayer():GetNWString("sboxmoneyinvselected") )
					net.WriteFloat( LocalPlayer():GetNWFloat("sboxmoneyinvtodrop" ) )
				net.SendToServer()
				if LocalPlayer().SandboxMoneyWindow then LocalPlayer().SandboxMoneyWindow:Close() LocalPlayer().SandboxMoneyWindow = nil end
				if LocalPlayer().SubWindow then LocalPlayer().SubWindow:Close() LocalPlayer().SubWindow = nil end
			end
		end
		
		--------------------------------------------------------------------------
		
		local mg = vgui.Create("DListView", LocalPlayer().SandboxMoneyWindow)
		mg:SetPos(160, 35)
		mg:SetSize(275+160, 330)
		mg:AddColumn("Items")
		mg.Paint = function() 
			local w = mg:GetWide()
			local t = mg:GetTall()
			
			draw.RoundedBox(0, 0, 0, w, t, Color(255, 255, 255, alph * 0.5))
		end
		if LocalPlayer():GetNWFloat("sboxmoneyamount") > 0 then
			mg:AddLine(CURRENCY_NAME .. "(s) (" .. math.floor(LocalPlayer():GetNWFloat("sboxmoneyamount")) .. ")", "")
		end
		-- for k, v in pairs(self.Owner.Slaves) do
			-- if IsValid( v ) then
				-- mg:AddLine(v:GetName(), "")
			-- end
		-- end
		mg.OnClickLine = function(parent, line, isselected)
			if not line:IsLineSelected() then
				for k, line in ipairs( parent:GetLines() ) do
					line:SetSelected(false)
				end
			end
			line:SetSelected(not line:IsLineSelected())
			if line:IsLineSelected() then
				LocalPlayer():SetNWString("sboxmoneyinvselected", string.Split(line:GetColumnText(1), "(")[1])
			else 
				LocalPlayer():SetNWString("sboxmoneyinvselected", "" )
			end
		end
	end
end )
	
end