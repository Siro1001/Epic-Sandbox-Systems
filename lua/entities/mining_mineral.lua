AddCSLuaFile()

ENT.Type			= "anim"
ENT.Base			= "base_anim"
ENT.PrintName		= "Mineral"
ENT.Author			= "Xaxidoro"
ENT.Purpose 		= ""
ENT.Category		= "Epic Sandbox Systems"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true 

ENT.Rarity = 0		-- { Copper, Silver, Gold, Platinum, Xen }
ENT.Size = 0		-- { Big, Medium, Small, Pickup }
ENT.Spawned = true		
ENT.Broken = false
ENT.CreateTime = 0

ENT.BigMdls = { 
	"models/props_wasteland/rockgranite02c.mdl",
	"models/props_wasteland/rockgranite02a.mdl",
	"models/props_wasteland/rockgranite02b.mdl",
}
ENT.MediumMdls = { 
	"models/props_wasteland/rockgranite03c.mdl",
	"models/props_wasteland/rockgranite03a.mdl",
	"models/props_wasteland/rockgranite03b.mdl",
}
ENT.SmallMdls = { 
	"models/props_debris/concrete_chunk08a.mdl",
	"models/props_debris/concrete_chunk03a.mdl",
}
ENT.Pickup = { 
	"models/props_debris/concrete_chunk05g.mdl",
}

if SERVER then
	
	function ENT:Initialize()
	
		self.Size = self.Entity:GetNWInt( "MineralSize", 0 )
		self.Rarity = self.Entity:GetNWInt( "MineralRarity", 0 )
		self.Spawned = self.Entity:GetNWBool( "MineralSpawned", true )
		self.CreateTime = CurTime()
	
		if self.Size == 0 then self:SetModel( self.BigMdls[math.random(table.Count(self.BigMdls))] ) end
		if self.Size == 1 then self:SetModel( self.MediumMdls[math.random(table.Count(self.MediumMdls))] ) end
		if self.Size == 2 then self:SetModel( self.SmallMdls[math.random(table.Count(self.SmallMdls))] ) end
		if self.Size == 3 then self:SetModel( self.Pickup[math.random(table.Count(self.Pickup))] ) end
		
		if self.Rarity == 0 then self:SetMaterial( "models/player/shared/ice_player" ) self:SetColor(Color(255,127,0,255)) end
		if self.Rarity == 1 then self:SetMaterial( "models/player/shared/ice_player" ) self:SetColor(Color(255,255,255,255)) end
		if self.Rarity == 2 then self:SetMaterial( "models/player/shared/gold_player" ) self:SetColor(Color(255,255,255,255)) end
		if self.Rarity == 3 then self:SetMaterial( "models/player/shared/ice_player" ) self:SetColor(Color(0,127,255,255)) end
		if self.Rarity == 4 then self:SetMaterial( "models/props_lab/xencrytal_sheet" ) self:SetColor(Color(255,255,255,255)) end
		
		self:SetHealth( (4 - self.Size) * (self.Rarity + 2) / 2 * 30 )
		if self.Size == 3 then self:SetHealth( 1 ) end
		
		self:SetRenderMode( RENDERMODE_TRANSCOLOR )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:GetPhysicsObject():SetMass( 1 )
		if self.Size == 3 then 
			self:SetCollisionGroup( COLLISION_GROUP_WEAPON ) 
			self:SetTrigger( true )
		else
			self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE_DEBRIS ) 
		end
		
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
		
		if self.Spawned then
			self.Entity:EmitSound( "ambience/des_wind2.wav" )
		end
	end

	function ENT:SpawnFunction( ply, tr )
		
		if !tr.Hit then return end

		local SpawnPos = tr.HitPos + tr.HitNormal * 1

		local ent = ents.Create( "mining_mineral" )
		ent:SetPos( SpawnPos )
		ent:Spawn()
		ent:Activate()
		
		return ent
	end
	
	function ENT:Use( activator, caller )
		if self.Size < 3 then return end
		if not activator:IsPlayer() then return end
		if not activator == self.Entity:GetOwner() and self.CreateTime + 15 <= CurTime() then return end
		
		self.Entity:EmitSound( "physics/metal/metal_grenade_impact_hard2.wav" )
		
		--SANDBOXMONEY.SandboxMoneyAddCurrency( activator, 5 * math.max(1, self.Rarity * (self.Rarity + 1)) )
		SANDBOXMONEY.SandboxMoneyAddOre( activator, self.Rarity, 1 )
		
		self.Entity:Remove()
	end
	
	function ENT:StartTouch( entity )
		if self.Size < 3 then return end
		if not entity:IsPlayer() then return end
		if not entity == self.Entity:GetOwner() and self.CreateTime + 15 <= CurTime() then return end

		self.Entity:EmitSound( "physics/metal/metal_grenade_impact_hard2.wav" )
		
		--SANDBOXMONEY.SandboxMoneyAddCurrency( entity, 5 * math.max(1, self.Rarity * (self.Rarity + 1)) )
		SANDBOXMONEY.SandboxMoneyAddOre( entity, self.Rarity, 1 )
		
		self.Entity:Remove()
	end
	
	function ENT:Think() 
		self.Entity:RemoveAllDecals()
		if self.Spawned then
			self:SetColor( Color(self.Entity:GetColor().r, self.Entity:GetColor().g, self.Entity:GetColor().b, (CurTime() - self.CreateTime) * 64) )
		end
	end

	function ENT:OnTakeDamage(dmginfo)
			
		if self.Size > 2 then return end
		
		self.Entity:SetHealth( self.Entity:Health() - dmginfo:GetDamage() )
		
		if self.Entity:Health() <= 0 and not self.Broken then
			self.Broken = true
			if self.Size < 2 then
				local precise = 2
				if dmginfo:GetAttacker():GetActiveWeapon():GetClass() == "weapon_mad_pickaxe" then					
					local overflow = dmginfo:GetAttacker():GetNWInt("sboxmoneyminingprecise", 0) * 1.5
					while overflow > 0 do
						if math.random(0,100) < overflow then
							precise = precise + 1
						end
						overflow = overflow - 100
					end
				end
				for i=1,precise do
					local subRock = ents.Create("mining_mineral")
						subRock:SetNWInt( "MineralSize", self.Size + 1 ) --subRock.Size = self.Size + 1
						subRock:SetNWInt( "MineralRarity", self.Rarity ) --subRock.Rarity = self.Rarity
						subRock:SetNWBool( "MineralSpawned", false ) --subRock.Rarity = self.Rarity
						
						local pos = self.Entity:GetPos()
						subRock:SetPos(pos)

						subRock:SetAngles(Angle(math.random(1, 360), math.random(1, 360), math.random(1, 360)))
						subRock:Spawn()
						if i == 3 then
							subRock:EmitSound( "physics/metal/sawblade_stick3.wav" )
						end
				end
			end
			local bonus = 1
			if dmginfo:GetAttacker():GetActiveWeapon():GetClass() == "weapon_mad_pickaxe" then
				local overflow = dmginfo:GetAttacker():GetNWInt("sboxmoneyminingbonus", 0) * 7.5
				while overflow > 0 do
					if math.random(0,100) < overflow then
						bonus = bonus + 1
					end
					overflow = overflow - 100
				end
			end
			for i=1,bonus do
				local magic = math.random(0,100) < dmginfo:GetAttacker():GetNWInt("sboxmoneyminingmagic", 0) * 0.5
				local gem = ents.Create("mining_mineral")
					gem:SetNWInt( "MineralSize", 3 ) --gem.Size = 3
					gem:SetNWInt( "MineralRarity", self.Rarity + (magic and 1 or 0) ) --gem.Rarity = self.Rarity
					gem:SetNWBool( "MineralSpawned", false ) --gem.Rarity = self.Rarity
					
					local pos = self.Entity:GetPos()
					gem:SetOwner( dmginfo:GetAttacker() )
					gem:SetPos(pos + VectorRand(-1,1) * 5)

					gem:SetAngles(Angle(math.random(1, 360), math.random(1, 360), math.random(1, 360)))
					gem:Spawn()
				if magic then
					gem:EmitSound( "garrysmod/save_load4.wav" )
				elseif i == 1 and bonus > 1 then
					gem:EmitSound( "garrysmod/balloon_pop_cute.wav" )
				end
			end
			
			self.Entity:EmitSound( "physics/concrete/boulder_impact_hard4.wav" )
			self.Entity:Remove()
		end
	end

end

if CLIENT then
	function ENT:Initialize()
	end

	function ENT:Draw()
	
		self.CreateTime = CurTime()
		self:DrawModel()
		
	end
	
	--killicon.Add( "banana", "weapons/bananaicon", Color ( 0, 255, 0, 255 ) )
	
end