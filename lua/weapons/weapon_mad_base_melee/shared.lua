SWEP.Base 			= "weapon_mad_base"
SWEP.MadCow = true

SWEP.UseHands = true

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false

SWEP.ViewModel				= ""
SWEP.WorldModel				= ""

SWEP.Weight					= 5
SWEP.AutoSwitchTo				= false
SWEP.AutoSwitchFrom			= false
SWEP.HoldType = "knife"

SWEP.Primary.Delay 				= 0.5
SWEP.Primary.Anim				= ACT_VM_MISSCENTER
SWEP.Primary.SwingTime			= 0
SWEP.Primary.SwingAngle			= 0
SWEP.Primary.MeleeSweep			= 30
SWEP.Primary.NumShots			= 3 -- * 2 + 1
SWEP.Primary.Damage				= 35
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo				= "none"
SWEP.Primary.HullSize			= 0

SWEP.Secondary.Delay 			= 1
SWEP.Secondary.Anim				= ACT_VM_SWINGHARD
SWEP.Secondary.SwingTime		= 0
SWEP.Secondary.SwingAngle		= 90
SWEP.Secondary.MeleeSweep		= 40
SWEP.Secondary.NumShots			= 0 -- * 2 + 1
SWEP.Secondary.Damage			= 55
SWEP.Secondary.Backstab			= 99999999
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.HullSize			= 0

SWEP.MeleeRange			= 60
SWEP.DamageType	= DMG_CLUB

SWEP.Pistol				= true
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.HitSound				= Sound("Weapon_Knife.Hit")
SWEP.CriticalSound			= Sound("Weapon_Knife.Stab")
SWEP.MissSound 				= Sound("weapons/knife/knife_slash1.wav")
SWEP.WallSound 				= Sound("weapons/knife/knife_hitwall1.wav")
SWEP.DeploySound			= nil
SWEP.HitSoundPlayed			= false

SWEP.RunArmOffset = Vector(0,0,-6)
SWEP.RunArmAngle = Vector(0,0,0)

SWEP.HoldingPos = Vector(0,0,0)

SWEP.HitTargets = {}

if (CLIENT) then
	
	function SWEP:DrawHUD()
		if self.Weapon:GetDTBool(0) then return end
		
        x = ScrW() / 2
        y = ScrH() / 2
		
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(x - 2, y - 1, 3, 3)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(x - 1, y, 1, 1)
	end

end

function SWEP:Shock( attacker, entity, n )
end

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function SWEP:Initialize()

	self:SetWeaponHoldType(self.HoldType) 	-- Hold type of the 3rd person animation
end

/*---------------------------------------------------------
   Name: SWEP:Think()
   Desc: Called every frame.
---------------------------------------------------------*/
function SWEP:Think()

	self:SecondThink()
	self:IdleThink()

	if self.Weapon:GetDTBool(0) then
		self:SetWeaponHoldType( 'normal' )
		self:SetHoldType( 'normal' )
	else
		self:SetWeaponHoldType(self.HoldType)
		self:SetHoldType(self.HoldType)
	end

	self:NextThink(CurTime())
end

/*---------------------------------------------------------
   Name: SWEP:Deploy()
---------------------------------------------------------*/
function SWEP:Deploy()

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)

	if self.DeploySound then
		self.Weapon:EmitSound(self.DeploySound, 50, 100)
	end

	return true
end

function SWEP:SecondaryAnim()
	self.Weapon:SendWeaponAnim(self.Secondary.Anim)
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

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Secondary.Delay + self.Secondary.SwingTime)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Delay + self.Secondary.SwingTime)
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
   Name: SWEP:ESecondary()
   Desc: +attack2+E has been pressed.
---------------------------------------------------------*/
function SWEP:ESecondary()
	
end

function SWEP:SecondaryOnHit(attacker, tr, dmginfo)

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
			endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * self.MeleeRange ),
			filter = self.Owner,
			mins = Vector( -0.1, -0.1, -0.1 ) * self.Secondary.HullSize,
			maxs = Vector( 0.1, 0.1, 0.1 ) * self.Secondary.HullSize,
			mask = MASK_SHOT_HULL
		} )
	else
		tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * self.MeleeRange ),
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
			bullet.Distance = self.MeleeRange
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
				endpos = self.Owner:GetShootPos() + ( aimVector * self.MeleeRange ),
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
					bullet.Distance = self.MeleeRange
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
	
	timer.Simple(self.Secondary.Delay - 0.05, function() table.Empty( self.HitTargets ) end)

	self.HitSoundPlayed = false
end

function SWEP:PrimaryAnim()
	self.Weapon:SendWeaponAnim(self.Primary.Anim)
end

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

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay + self.Primary.SwingTime)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay + self.Primary.SwingTime)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	self:PrimaryAnim()
	
	if not IsFirstTimePredicted() then return end
	
	if self.Primary.SwingTime <= 0 then
		timer.Simple( 0, function() self:PrimaryAttackFilter() end )
		return
	end
	timer.Simple( self.Primary.SwingTime, function() self:PrimaryAttackFilter() end )
	
end

function SWEP:PrimaryOnHit(attacker, tr, dmginfo)

end

function SWEP:PrimaryAttackFilter()

	if CLIENT then return end
	
	self.Weapon:EmitSound(self.MissSound,100,math.random(90,120))
	
	local tr = {}
	if self.Primary.HullSize > 0 then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * self.MeleeRange ),
			filter = self.Owner,
			mins = Vector( -0.1, -0.1, -0.1 ) * self.Primary.HullSize,
			maxs = Vector( 0.1, 0.1, 0.1 ) * self.Primary.HullSize,
			mask = MASK_SHOT_HULL
		} )
	else
		tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * self.MeleeRange ),
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
			bullet.Distance = self.MeleeRange
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
				endpos = self.Owner:GetShootPos() + ( aimVector * self.MeleeRange ),
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
					bullet.Distance = self.MeleeRange
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
	timer.Simple(self.Primary.Delay - 0.05, function() table.Empty( self.HitTargets ) end)
	
	self.HitSoundPlayed = false
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()
	return false

end

/*---------------------------------------------------------
ShootEffects
---------------------------------------------------------*/
function SWEP:ShootEffects()
end

function SWEP:IronSight()
end

/*---------------------------------------------------------
SetIronsights
---------------------------------------------------------*/
function SWEP:SetIronsights(b)
	self.Weapon:SetNetworkedBool("Ironsights", b)
end

function SWEP:GetIronsights()
	return self.Weapon:GetNWBool("Ironsights")
end

SWEP.NextSecondaryAttack = 0
