if CLIENT then
	
hook.Add( "InitPostEntity", "DisplayFloatingTextBoxesInit", function() 
	LocalPlayer().FloatingTextBoxesList = {}
end )

hook.Add( "ChatTextChanged", "FloatingTextBoxesDisplay", function( text )
	net.Start( "UpdateFloatingTextBoxesDisplay" )
		net.WriteString( text )
	net.SendToServer()
end )
hook.Add( "FinishChat", "FloatingTextBoxesDisplayFinish", function()
	net.Start( "UpdateFloatingTextBoxesDisplay" )
		net.WriteString( "" )
	net.SendToServer()
end )

net.Receive( "UpdateFloatingTextBoxesDisplay", function( len, ply )
	local text = net.ReadString()
	local pos = net.ReadVector()
	local index = net.ReadString()
	
	local toadd = {}
		toadd[index] = { ""..(CurTime() + 5), ""..pos.x, ""..pos.y, ""..pos.z, text }
	table.Merge( LocalPlayer().FloatingTextBoxesList, toadd )
end )

hook.Add("PostDrawOpaqueRenderables", "DisplayFloatingTextBoxesDisplay", function()	
	for k, v in pairs( LocalPlayer().FloatingTextBoxesList ) do
		if tonumber(v[1]) < CurTime() then LocalPlayer().FloatingTextBoxesList[k] = nil goto skip_to_next end
		if v[5] == "" then LocalPlayer().FloatingTextBoxesList[k] = nil goto skip_to_next end
		local angle = EyeAngles() 
		angle = Angle( 0, angle.y, 0 ) 
		angle.y = angle.y + math.sin( CurTime() ) * 10
		angle:RotateAroundAxis( angle:Up(), -90 )
		angle:RotateAroundAxis( angle:Forward(), 90 )
		
		cam.Start3D2D( Vector( tonumber(v[2]), tonumber(v[3]), tonumber(v[4]) ), angle, .25 )
			local text = v[5]
			surface.SetFont( "TargetIDSmall" )
			local tW, tH = surface.GetTextSize( text )

			-- This defines amount of padding for the box around the text
			local pad = 5

			-- Draw a rectable. This has to be done before drawing the text, to prevent overlapping
			-- Notice how we start drawing in negative coordinates
			-- This is to make sure the 3d2d display rotates around our position by its center, not left corner
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawRect( -tW / 2 - pad - 1, -pad - 1, tW + pad * 2 + 2, tH + pad * 2 + 2 )
			surface.SetDrawColor( 64, 64, 64, 255 )
			surface.DrawRect( -tW / 2 - pad, -pad, tW + pad * 2, tH + pad * 2 )
			draw.SimpleText( text, "TargetIDSmall", -tW / 2, 0, color_white )
		cam.End3D2D()
		::skip_to_next::
	end
end )

end

if SERVER then

util.AddNetworkString( "UpdateFloatingTextBoxesDisplay" )

net.Receive( "UpdateFloatingTextBoxesDisplay", function( len, ply )
	local text = net.ReadString()
	
	for k, v in ipairs( player.GetHumans() ) do
		if ply:GetPos():DistToSqr( v:GetPos() ) < 250000 then
			net.Start( "UpdateFloatingTextBoxesDisplay" )
				net.WriteString( text )
				net.WriteVector( ply:GetPos() + Vector(0,0,72) )
				net.WriteString( ply:SteamID() )
			net.Send( v )
		end
	end
end )

end