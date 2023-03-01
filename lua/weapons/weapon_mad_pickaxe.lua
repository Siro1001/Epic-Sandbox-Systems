if (SERVER) then

	AddCSLuaFile()
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo			= false
	SWEP.AutoSwitchFrom		= false

end

if ( CLIENT ) then
	SWEP.PrintName			= "PICKAXE"
	SWEP.Author				= "Xaxidoro"
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= false
	SWEP.CSMuzzleFlashes		= false
	
	SWEP.Slot				= 0
	SWEP.SlotPos			= 2
	SWEP.IconLetter			= "n"

	SWEP.WepSelectIcon = surface.GetTextureID( "vgui/hud/weapon_mad_pickaxe" )
	killicon.Add( "weapon_mad_pickaxe", "vgui/hud/weapon_mad_pickaxe", Color( 255, 80, 0, 191 ) )
end

SWEP.Base 					= "weapon_mad_base_melee"
SWEP.Category				= "Epic Sandbox Systems"

SWEP.UseHands = true

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel				= "models/weapons/c_pickaxe.mdl"
SWEP.WorldModel				= "models/weapons/w_pickaxe.mdl"
SWEP.ViewModelFOV			= 56
SWEP.ViewModelFlip		= false

SWEP.Weight					= 5
SWEP.AutoSwitchTo				= false
SWEP.AutoSwitchFrom			= false
SWEP.HoldType = "melee"

SWEP.Primary.Delay 				= 0.6
SWEP.Primary.Anim				= ACT_VM_MISSCENTER
SWEP.Primary.SwingAngle			= -35 + 180
SWEP.Primary.MeleeSweep			= 15
SWEP.Primary.NumShots			= 3 -- * 2 + 1
SWEP.Primary.Damage				= 6
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo				= "none"
SWEP.Primary.HullSize 			= 1

SWEP.Secondary.Delay 			= 0.6
SWEP.Secondary.Anim				= ACT_VM_HITCENTER
SWEP.Secondary.SwingAngle		= 90
SWEP.Secondary.MeleeSweep		= 0
SWEP.Secondary.NumShots			= 0 -- * 2 + 1
SWEP.Secondary.Damage			= 30
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.HullSize 		= 1

SWEP.MeleeRange				= 60

SWEP.Pistol				= false
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.HitSound				= Sound("physics/concrete/concrete_impact_hard1.wav")
SWEP.CriticalSound			= Sound("physics/concrete/concrete_impact_hard1.wav")
SWEP.MissSound 				= Sound("weapons/knife/knife_slash1.wav")
SWEP.WallSound 				= Sound("Weapon_Crowbar.Melee_HitWorld")

SWEP.DeploySound			= nil

SWEP.RunArmOffset = Vector(0,0,-8)
SWEP.RunArmAngle = Vector(0,0,0)

SWEP.HoldingPos = Vector(0,0,0)

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack()
   Desc: +attack1 has been pressed.
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	
	// Holst/Deploy your fucking weapon
	if (not self.Owner:IsNPC() and self.Owner:KeyDown(IN_USE)) then
		bHolsted = !self.Weapon:GetDTBool(0)
		self:SetHolsted(bHolsted)

		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)

		self:SetIronsights(false)

		return
	end
	
	if self.Weapon:GetDTBool(0) --[[or self.Owner:KeyDown(IN_SPEED)--]] then return end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay + self.Primary.SwingTime - self.Owner:GetNWInt("sboxmoneyminingspeed", 0) * 0.008)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay + self.Primary.SwingTime - self.Owner:GetNWInt("sboxmoneyminingspeed", 0) * 0.008)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	self:PrimaryAnim()
	
	if not IsFirstTimePredicted() then return end
	
	if self.Primary.SwingTime <= 0 then
		timer.Simple( 0, function() self:PrimaryAttackFilter() end )
		return
	end
	timer.Simple( self.Primary.SwingTime, function() self:PrimaryAttackFilter() end )
	
end

function SWEP:PrimaryAttackFilter()

	if CLIENT then return end
	
	self.Weapon:EmitSound(self.MissSound,100,math.random(90,120))
	
	local tr = {}
	if self.Primary.HullSize > 0 then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * (self.MeleeRange + self.Owner:GetNWInt("sboxmoneyminingrange", 0)) ),
			filter = self.Owner,
			mins = Vector( -0.1, -0.1, -0.1 ) * self.Primary.HullSize,
			maxs = Vector( 0.1, 0.1, 0.1 ) * self.Primary.HullSize,
			mask = MASK_SHOT_HULL
		} )
	else
		tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * (self.MeleeRange + self.Owner:GetNWInt("sboxmoneyminingrange", 0)) ),
			filter = self.Owner,
			mask = MASK_SHOT_HULL
		} )
	end
	if tr.Hit then	
		local EntityAlreadyHit = self.HitTargets[tr.Entity:EntIndex()] ~= nil
		if not EntityAlreadyHit then
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 10
			bullet.Damage = self.Primary.Damage
			bullet.HullSize = self.Primary.HullSize or 0
			bullet.Distance = self.MeleeRange + self.Owner:GetNWInt("sboxmoneyminingrange", 0)
			bullet.AmmoType = "pistol"
			bullet.Callback	= function(attacker, tr, dmginfo) 
				dmginfo:SetDamageType(self.DamageType)
				if tr.Entity:IsValid() then
					self:PrimaryOnHit(attacker, tr, dmginfo)
				end
			end
			self.Owner:FireBullets(bullet)
		end
		self.HitTargets[tr.Entity:EntIndex()] = 1
		
		--dmginfo:SetDamageType(self.DamageType)
		if not self.HitSoundPlayed then 
			if tr.Entity:IsValid() then
				--self:PrimaryOnHit(attacker, tr, dmginfo)
				self.Weapon:EmitSound(self.HitSound)
				self.HitSoundPlayed = true
			else
				self.Weapon:EmitSound(self.WallSound)
				self.HitSoundPlayed = true
			end
		end
	end
	--self.Owner:FireBullets(bullet)
	
	local swingAngle = self.Owner:GetAimVector():Angle():Up():Angle()
	swingAngle:RotateAroundAxis( self.Owner:GetAimVector(), self.Primary.SwingAngle )
	
	-- Override for new trace system
	local realshots = self.Primary.MeleeSweep / 5 + 1
	
	if self.Primary.NumShots > 1 then
		local mini = -1 local maxi = realshots * 2 - 2 local mean = (mini + maxi) / 2
	
		for i = -1, realshots * 2 - 2 do
		
			local aim = self.Owner:GetAimVector():Angle()
			aim:RotateAroundAxis( swingAngle:Forward(), self.Primary.MeleeSweep - 2 * self.Primary.MeleeSweep * i / realshots )
			local aimVector = aim:Forward()
			
			local tr = util.TraceLine( {
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + ( aimVector * (self.MeleeRange + self.Owner:GetNWInt("sboxmoneyminingrange", 0)) ),
				filter = self.Owner,
				mask = MASK_SHOT_HULL
			} )
			if tr.Hit then	
				local EntityAlreadyHit = self.HitTargets[tr.Entity:EntIndex()] ~= nil
				if not EntityAlreadyHit then
					bullet = {}
					bullet.Num    = 1
					bullet.Src    = self.Owner:GetShootPos()
					bullet.Dir    = aimVector
					bullet.Spread = Vector(0, 0, 0)
					bullet.Tracer = 0
					bullet.Force  = 10
					bullet.Damage = self.Primary.Damage
					bullet.HullSize = self.Primary.HullSize or 0
					bullet.Distance = self.MeleeRange + self.Owner:GetNWInt("sboxmoneyminingrange", 0)
					bullet.AmmoType = "pistol"
					bullet.Callback	= function(attacker, tr, dmginfo) 
						dmginfo:SetDamageType(self.DamageType) 
						if tr.Entity:IsValid() then
							self:PrimaryOnHit(attacker, tr, dmginfo)
						end
					end
					self.Owner:FireBullets(bullet)
				end
				self.HitTargets[tr.Entity:EntIndex()] = 1
				
				--dmginfo:SetDamageType(self.DamageType)
				if not self.HitSoundPlayed then 
					if tr.Entity:IsValid() then
						--self:PrimaryOnHit(attacker, tr, dmginfo)
						self.Weapon:EmitSound(self.HitSound)
						self.HitSoundPlayed = true
					else
						self.Weapon:EmitSound(self.WallSound)
						self.HitSoundPlayed = true
					end
				end
			end
			--self.Owner:FireBullets(bullet)
		end
	end
	timer.Simple(self.Primary.Delay - self.Owner:GetNWInt("sboxmoneyminingspeed", 0) - 0.05, function() table.Empty( self.HitTargets ) end)
	
	self.HitSoundPlayed = false
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	// Holst/Deploy your fucking weapon
	if (not self.Owner:IsNPC() and self.Owner:KeyDown(IN_USE)) then
		if self.Weapon:GetDTBool(0) or self.Owner:KeyDown(IN_SPEED) then return end
			self.Weapon:ESecondary()
		return
	end

	if self.Weapon:GetDTBool(0) --[[or self.Owner:KeyDown(IN_SPEED)--]] then return end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Secondary.Delay + self.Secondary.SwingTime - self.Owner:GetNWInt("sboxmoneyminingspeed", 0) * 0.008)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Delay + self.Secondary.SwingTime - self.Owner:GetNWInt("sboxmoneyminingspeed", 0) * 0.008)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	self:SecondaryAnim()
	
	if not IsFirstTimePredicted() then return end
	
	if self.Secondary.SwingTime <= 0 then
		timer.Simple( 0, function() self:SecondaryAttackFilter() end )
		return
	end
	timer.Simple( self.Secondary.SwingTime, function() self:SecondaryAttackFilter() end )
	
end
	
/*---------------------------------------------------------
   Name: SWEP:SecondaryAttackFilter()
   Desc: +attack2 has been pressed, and everything else has been processed
---------------------------------------------------------*/
function SWEP:SecondaryAttackFilter()

	if CLIENT then return end

	self.Weapon:EmitSound(self.MissSound,100,math.random(90,120))
	
	local tr = {}
	if self.Secondary.HullSize > 0 then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * (self.MeleeRange + self.Owner:GetNWInt("sboxmoneyminingrange", 0)) ),
			filter = self.Owner,
			mins = Vector( -0.1, -0.1, -0.1 ) * self.Secondary.HullSize,
			maxs = Vector( 0.1, 0.1, 0.1 ) * self.Secondary.HullSize,
			mask = MASK_SHOT_HULL
		} )
	else
		tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * (self.MeleeRange + self.Owner:GetNWInt("sboxmoneyminingrange", 0)) ),
			filter = self.Owner,
			mask = MASK_SHOT_HULL
		} )
	end
	
	if tr.Hit then		
		local EntityAlreadyHit = self.HitTargets[tr.Entity:EntIndex()] ~= nil
		if not EntityAlreadyHit then
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 10
			bullet.Damage = self.Secondary.Damage
			bullet.HullSize = self.Secondary.HullSize or 0
			bullet.Distance = self.MeleeRange + self.Owner:GetNWInt("sboxmoneyminingrange", 0)
			bullet.AmmoType = "pistol"
			bullet.Callback	= function(attacker, tr, dmginfo) 
				dmginfo:SetDamageType(self.DamageType)
				if tr.Entity:IsValid() then
					self:SecondaryOnHit(attacker, tr, dmginfo)
				end
			end
			self.Owner:FireBullets(bullet)
		end
		self.HitTargets[tr.Entity:EntIndex()] = 1
				
		--dmginfo:SetDamageType(self.DamageType)
		if not self.HitSoundPlayed then 
			if tr.Entity:IsValid() then
				--self:SecondaryOnHit(attacker, tr, dmginfo)
				self.Weapon:EmitSound(self.HitSound)
				self.HitSoundPlayed = true
			else
				self.Weapon:EmitSound(self.WallSound)
				self.HitSoundPlayed = true
			end
		end
	end
	--self.Owner:FireBullets(bullet)

	local swingAngle = self.Owner:GetAimVector():Angle():Up():Angle()
	swingAngle:RotateAroundAxis( self.Owner:GetAimVector(), self.Secondary.SwingAngle )
	
	-- Override for new trace system
	local realshots = self.Secondary.MeleeSweep / 5 + 1
	
	if self.Secondary.NumShots > 1 then
		local mini = -1 local maxi = realshots * 2 - 2 local mean = (mini + maxi) / 2
		for i = -1, realshots * 2 - 2 do
		
			local aim = self.Owner:GetAimVector():Angle()
			aim:RotateAroundAxis( swingAngle:Forward(), self.Secondary.MeleeSweep - 2 * self.Secondary.MeleeSweep * i / realshots )
			local aimVector = aim:Forward()
			
			local tr = util.TraceLine( {
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + ( aimVector * (self.MeleeRange + self.Owner:GetNWInt("sboxmoneyminingrange", 0)) ),
				filter = self.Owner,
				mask = MASK_SHOT_HULL
			} )
			if tr.Hit then
				local EntityAlreadyHit = self.HitTargets[tr.Entity:EntIndex()] ~= nil
				if not EntityAlreadyHit then
					bullet = {}
					bullet.Num    = 1
					bullet.Src    = self.Owner:GetShootPos()
					bullet.Dir    = aimVector
					bullet.Spread = Vector(0, 0, 0)
					bullet.Tracer = 0
					bullet.Force  = 10
					bullet.Damage = self.Secondary.Damage
					bullet.HullSize = self.Secondary.HullSize or 0
					bullet.Distance = self.MeleeRange + self.Owner:GetNWInt("sboxmoneyminingrange", 0)
					bullet.AmmoType = "pistol"
					bullet.Callback	= function(attacker, tr, dmginfo)
						dmginfo:SetDamageType(self.DamageType) 
						if tr.Entity:IsValid() then
							self:SecondaryOnHit(attacker, tr, dmginfo)
						end
					end
					self.Owner:FireBullets(bullet)
				end
				self.HitTargets[tr.Entity:EntIndex()] = 1
			
				--dmginfo:SetDamageType(self.DamageType)
				if not self.HitSoundPlayed then 
					if tr.Entity:IsValid() then
						--self:SecondaryOnHit(attacker, tr, dmginfo)
						self.Weapon:EmitSound(self.HitSound)
						self.HitSoundPlayed = true
					else
						self.Weapon:EmitSound(self.WallSound)
						self.HitSoundPlayed = true
					end
				end
			end
			--self.Owner:FireBullets(bullet)
		end
	end
	
	timer.Simple(self.Secondary.Delay - self.Owner:GetNWInt("sboxmoneyminingspeed", 0) - 0.05, function() table.Empty( self.HitTargets ) end)

	self.HitSoundPlayed = false
end