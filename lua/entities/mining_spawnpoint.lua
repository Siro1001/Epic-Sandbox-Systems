AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Mineral Spawnpoint"
ENT.Author			= "Xaxidoro"
ENT.Information		= ""
ENT.Category		= "Epic Sandbox Systems"

ENT.Spawnable		= true
ENT.AdminOnly 		= true

if CLIENT then

	language.Add("mining_spawnpoint", "Mineral Spawnpoint")

	/*---------------------------------------------------------
	   Name: Initialize
	---------------------------------------------------------*/
	function ENT:Initialize()
	
	end

	/*---------------------------------------------------------
	   Name: DrawPre
	---------------------------------------------------------*/
	function ENT:Draw()
	
		if not LocalPlayer():IsAdmin() then return end
		
		self.Entity:DrawModel()

		local FixAngles = self.Entity:GetAngles()
		local FixRotation = Vector(90, 270, 0)

		FixAngles:RotateAroundAxis(FixAngles:Right(), FixRotation.x)
		FixAngles:RotateAroundAxis(FixAngles:Up(), FixRotation.y)
		FixAngles:RotateAroundAxis(FixAngles:Forward(), FixRotation.z)

		FixAngles:RotateAroundAxis(FixAngles:Right(), self.Entity:GetAngles().y)
		FixAngles:RotateAroundAxis(FixAngles:Up(), self.Entity:GetAngles().z)
		FixAngles:RotateAroundAxis(FixAngles:Forward(), self.Entity:GetAngles().x)
		
		local TargetPos = self.Entity:GetPos() + (LocalPlayer():GetUp() * 15)

		self.Text = "Spawnpoint"

		cam.Start3D2D(TargetPos, FixAngles, 0.2)
			draw.SimpleTextOutlined(self.Text, "ChatFont", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0))
		cam.End3D2D() 
		
		FixAngles:RotateAroundAxis(FixAngles:Right(), 180)

		cam.Start3D2D(TargetPos, FixAngles, 0.2)
			draw.SimpleTextOutlined(self.Text, "ChatFont", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0))
		cam.End3D2D() 
		
	end

end

if SERVER then

	/*---------------------------------------------------------
	   Name: Initialize
	---------------------------------------------------------*/
	function ENT:Initialize()

		// Use the helibomb model just for the shadow (because it's about the same size)
		self.Entity:SetModel("models/props_c17/streetsign004e.mdl")
		self.Entity:SetMaterial("models/shiny")
		self.Entity:SetColor(Color(255,255,255,255))
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:DrawShadow(false)
		self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		
		local phys = self.Entity:GetPhysicsObject()
		
		if (phys:IsValid()) then
			phys:Wake()
		end

		self.Entity:SetUseType(SIMPLE_USE)
	end

	function ENT:SpawnFunction( ply, tr )
		
		if !tr.Hit then return end

		local SpawnPos = tr.HitPos + tr.HitNormal * 1

		local ent = ents.Create( "mining_spawnpoint" )
		ent:SetPos( SpawnPos )
		ent:Spawn()
		ent:Activate()
		
		return ent
	end

	/*---------------------------------------------------------
	   Name: PhysicsCollide
	---------------------------------------------------------*/
	function ENT:PhysicsCollide(data, physobj)
		
		// Play sound on bounce
		if (data.Speed > 80 and data.DeltaTime > 0.2) then
			self.Entity:EmitSound("SolidMetal.ImpactSoft")
		end
	end

	/*---------------------------------------------------------
	   Name: OnTakeDamage
	---------------------------------------------------------*/
	function ENT:OnTakeDamage(dmginfo)

		// React physically when shot/getting blown
		self.Entity:TakePhysicsDamage(dmginfo)
	end

	/*---------------------------------------------------------
	   Name: Use
	---------------------------------------------------------*/
	function ENT:Use(activator, caller)
	
	end

end