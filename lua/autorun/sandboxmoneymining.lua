if CLIENT then

hook.Add( "Think", "mining_mineralDynamicLights", function()
	for k, v in ipairs( ents.FindByClass( "mining_mineral" ) ) do
		
		local dlight = DynamicLight( v:EntIndex(), v:GetNWInt( "MineralSize" ) == 3 )
		if ( dlight ) then
			dlight.pos = v:GetPos()
			if v:GetNWInt( "MineralRarity" ) == 1 then
				dlight.r = 255
				dlight.g = 255
				dlight.b = 255
			elseif v:GetNWInt( "MineralRarity" ) == 0 then
				dlight.r = 255
				dlight.g = 127
				dlight.b = 0
			elseif v:GetNWInt( "MineralRarity" ) == 2 then
				dlight.r = 255
				dlight.g = 255
				dlight.b = 0
			elseif v:GetNWInt( "MineralRarity" ) == 3 then
				dlight.r = 0
				dlight.g = 127
				dlight.b = 255
			elseif v:GetNWInt( "MineralRarity" ) == 4 then
				dlight.r = 64
				dlight.g = 32
				dlight.b = 0
			end
			dlight.brightness = 2
			dlight.Decay = 1000
			dlight.Size = 128 * (3.5 - v:GetNWInt( "MineralSize" ))
			dlight.DieTime = CurTime() + 1
		end
	end
end )

end

if SERVER then

util.AddNetworkString( "UpgradeMiningUpgradeMenu" )
util.AddNetworkString( "SellMiningUpgradeMenu" )

hook.Add( "PlayerInitialSpawn", "SandboxMoneyMiningUpgradesInitialSetup", function( ply )
	file.CreateDir("sandboxmoneyminingupgrades")
	if file.Exists("sandboxmoneyminingupgrades/" .. ply:SteamID64() .. ".txt", "DATA") then
		local amount = file.Read("sandboxmoneyminingupgrades/" .. ply:SteamID64() .. ".txt", "DATA")
		local amounts = string.Split( amount, " " )
		ply:SetNWInt("sboxmoneyminingspeed", amounts[1])
		ply:SetNWInt("sboxmoneyminingrange", amounts[2])
		ply:SetNWInt("sboxmoneyminingbonus", amounts[3])
		ply:SetNWInt("sboxmoneyminingprecise", amounts[4])
		ply:SetNWInt("sboxmoneyminingmagic", amounts[5])
	else
		file.Write("sandboxmoneyminingupgrades/" .. ply:SteamID64() .. ".txt", "0 0 0 0 0")
		ply:SetNWInt("sboxmoneyminingspeed", 0)
		ply:SetNWInt("sboxmoneyminingrange", 0)
		ply:SetNWInt("sboxmoneyminingbonus", 0)
		ply:SetNWInt("sboxmoneyminingprecise", 0)
		ply:SetNWInt("sboxmoneyminingmagic", 0)
	end
	
	file.CreateDir("sandboxmoneyminingores")
	if file.Exists("sandboxmoneyminingores/" .. ply:SteamID64() .. ".txt", "DATA") then
		local amount = file.Read("sandboxmoneyminingores/" .. ply:SteamID64() .. ".txt", "DATA")
		local amounts = string.Split( amount, " " )
		ply:SetNWInt("sboxmoneyminingcopper", amounts[1])
		ply:SetNWInt("sboxmoneyminingsilver", amounts[2])
		ply:SetNWInt("sboxmoneymininggold", amounts[3])
		ply:SetNWInt("sboxmoneyminingplatinum", amounts[4])
		ply:SetNWInt("sboxmoneyminingxen", amounts[5])
	else
		file.Write("sandboxmoneyminingores/" .. ply:SteamID64() .. ".txt", "0 0 0 0 0")
		ply:SetNWInt("sboxmoneyminingcopper", 0)
		ply:SetNWInt("sboxmoneyminingsilver", 0)
		ply:SetNWInt("sboxmoneymininggold", 0)
		ply:SetNWInt("sboxmoneyminingplatinum", 0)
		ply:SetNWInt("sboxmoneyminingxen", 0)
	end
	
	ply.sboxmoneyminingoreNeedsUpdate = false
	timer.Create( "sboxmoneyminingoreupdate"..ply:SteamID64(), 5, 0, function()
		if not IsValid( ply ) then return end
		if ply.sboxmoneyminingoreNeedsUpdate then
			ply.sboxmoneyminingoreNeedsUpdate = false
			file.Write("sandboxmoneyminingores/" .. ply:SteamID64() .. ".txt", 
				ply:GetNWInt("sboxmoneyminingcopper", 0) .. " " .. ply:GetNWInt("sboxmoneyminingsilver", 0) .. " " .. ply:GetNWInt("sboxmoneymininggold", 0) .. " " .. ply:GetNWInt("sboxmoneyminingplatinum", 0) .. " " .. ply:GetNWInt("sboxmoneyminingxen", 0))
		end
	end )
end )
hook.Add( "PlayerDisconnected", "SandboxMoneyMiningDeinitialize", function( ply )
	if not ply.SteamID64 then return end
	
	timer.Remove( "sboxmoneyminingoreupdate"..ply:SteamID64() )
	file.Write("sandboxmoneyminingores/" .. ply:SteamID64() .. ".txt", 
		ply:GetNWInt("sboxmoneyminingcopper", 0) .. " " .. ply:GetNWInt("sboxmoneyminingsilver", 0) .. " " .. ply:GetNWInt("sboxmoneymininggold", 0) .. " " .. ply:GetNWInt("sboxmoneyminingplatinum", 0) .. " " .. ply:GetNWInt("sboxmoneyminingxen", 0))
end )

function SANDBOXMONEY.SandboxMoneyAddOre( ply, rarity, amount )
	if rarity < 0 or rarity > 4 then return end
	
	if rarity == 0 then
		ply:SetNWInt("sboxmoneyminingcopper", ply:GetNWInt("sboxmoneyminingcopper", 0) + amount)
	elseif rarity == 1 then
		ply:SetNWInt("sboxmoneyminingsilver", ply:GetNWInt("sboxmoneyminingsilver", 0) + amount)
	elseif rarity == 2 then
		ply:SetNWInt("sboxmoneymininggold", ply:GetNWInt("sboxmoneymininggold", 0) + amount)
	elseif rarity == 3 then
		ply:SetNWInt("sboxmoneyminingplatinum", ply:GetNWInt("sboxmoneyminingplatinum", 0) + amount)
	else
		ply:SetNWInt("sboxmoneyminingxen", ply:GetNWInt("sboxmoneyminingxen", 0) + amount)
	end
	ply.sboxmoneyminingoreNeedsUpdate = true
end

net.Receive( "UpgradeMiningUpgradeMenu", function( len, ply )
	local upgradenum = net.ReadInt(4)
	local upgradecost = net.ReadFloat()
	
	SANDBOXMONEY.SandboxMoneyAddCurrency( ply, -1 * upgradecost )
	
	if upgradenum == 0 then ply:SetNWInt("sboxmoneyminingspeed", ply:GetNWInt("sboxmoneyminingspeed", 0) + 1) end
	if upgradenum == 1 then ply:SetNWInt("sboxmoneyminingrange", ply:GetNWInt("sboxmoneyminingrange", 0) + 1) end
	if upgradenum == 2 then ply:SetNWInt("sboxmoneyminingbonus", ply:GetNWInt("sboxmoneyminingbonus", 0) + 1) end
	if upgradenum == 3 then ply:SetNWInt("sboxmoneyminingprecise", ply:GetNWInt("sboxmoneyminingprecise", 0) + 1) end
	if upgradenum == 4 then ply:SetNWInt("sboxmoneyminingmagic", ply:GetNWInt("sboxmoneyminingmagic", 0) + 1) end
	file.Write("sandboxmoneyminingupgrades/" .. ply:SteamID64() .. ".txt", 
		ply:GetNWInt("sboxmoneyminingspeed", 0) .. " " .. ply:GetNWInt("sboxmoneyminingrange", 0) .. " " .. ply:GetNWInt("sboxmoneyminingbonus", 0) .. " " .. ply:GetNWInt("sboxmoneyminingprecise", 0) .. " " .. ply:GetNWInt("sboxmoneyminingmagic", 0))
	
	timer.Simple(0.2, function()
		net.Start( "OpenMiningUpgradeMenu" )
		net.Send( ply )
	end )
end )

net.Receive( "SellMiningUpgradeMenu", function( len, ply )
	local sellTier = net.ReadInt(4)
	local sellcoin = 0
	if sellTier == -1 or sellTier == 0 then
		sellcoin = sellcoin + 5 * math.max(1, 0 * (0 + 1)) * ply:GetNWInt("sboxmoneyminingcopper", 0)
		ply:SetNWInt("sboxmoneyminingcopper", 0)
	end
	if sellTier == -1 or sellTier == 1 then
		sellcoin = sellcoin + 5 * math.max(1, 1 * (1 + 1)) * ply:GetNWInt("sboxmoneyminingsilver", 0)
		ply:SetNWInt("sboxmoneyminingsilver", 0)
	end
	if sellTier == -1 or sellTier == 2 then
		sellcoin = sellcoin + 5 * math.max(1, 2 * (2 + 1)) * ply:GetNWInt("sboxmoneymininggold", 0)
		ply:SetNWInt("sboxmoneymininggold", 0)
	end
	if sellTier == -1 or sellTier == 3 then
		sellcoin = sellcoin + 5 * math.max(1, 3 * (3 + 1)) * ply:GetNWInt("sboxmoneyminingplatinum", 0)
		ply:SetNWInt("sboxmoneyminingplatinum", 0)
	end
	if sellcoin == 0 then return end
	SANDBOXMONEY.SandboxMoneyAddCurrency( ply, sellcoin )	
	file.Write("sandboxmoneyminingores/" .. ply:SteamID64() .. ".txt", 
		ply:GetNWInt("sboxmoneyminingcopper", 0) .. " " .. ply:GetNWInt("sboxmoneyminingsilver", 0) .. " " .. ply:GetNWInt("sboxmoneymininggold", 0) .. " " .. ply:GetNWInt("sboxmoneyminingplatinum", 0) .. " " .. ply:GetNWInt("sboxmoneyminingxen", 0))
	
	timer.Simple(0.2, function()
		net.Start( "OpenMiningUpgradeMenu" )
		net.Send( ply )
	end )
end )

local mining_mineralSpawnPointTime = 0
hook.Add( "Think", "mining_mineralSpawnPoints", function()
	if mining_mineralSpawnPointTime < CurTime() then
		mining_mineralSpawnPointTime = CurTime() + 60
		if table.Count( ents.FindByClass( "mining_mineral" ) ) > 15 then return end
		
		local tabl = ents.FindByClass( "mining_spawnpoint" )
		local index = math.random( table.Count( tabl ) )
		local spawnChosen = false
		if tabl == nil or table.Count(tabl) == 0 then return end
		
		while not spawnChosen do
			local tr = util.TraceLine( {
				start = tabl[index]:GetPos(),
				endpos = tabl[index]:GetPos() + VectorRand(-1,1) * 1000,
				filter = function( ent ) return ( ent:IsWorld() ) end
			} )
			spawnChosen = tr.Hit
			if spawnChosen then
				local entity = ents.Create("mining_mineral")
					entity:SetNWInt( "MineralSize", math.random(0,1) )
					entity:SetNWInt( "MineralRarity", math.random(0,2) )
					entity:SetPos(tr.HitPos + tr.HitNormal * 10)
					entity:Spawn()
					entity:Activate()
					entity:GetPhysicsObject():EnableMotion(false)
			end
		end
	end
end )

end