/*---------------------------------------------------------
------mmmm---mmmm-aaaaaaaa----ddddddddd---------------------------------------->
     mmmmmmmmmmmm aaaaaaaaa   dddddddddd	  Name: Mad Cows Weapons
     mmm mmmm mmm aaa    aaa  ddd     ddd	  Author: Worshipper
    mmm  mmm  mmm aaaaaaaaaaa ddd     ddd	  Project Start: October 23th, 2009
    mmm       mmm aaa     aaa dddddddddd	  Version: 2.0
---mmm--------mmm-aaa-----aaa-ddddddddd---------------------------------------->
---------------------------------------------------------*/

// Variables that are used on both client and server

game.AddParticles("particles/buu_particles.pcf")

local RecoilMul = CreateConVar ("mad_recoilmul", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE})
local DamageMul = CreateConVar ("mad_damagemul", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE})

SWEP.MadCow 			= true
SWEP.Category			= "Mad Cows Weapons"
SWEP.UseHands 				= true

SWEP.Author				= "Worshipper"
SWEP.Contact			= "Josephcadieux@hotmail.com"
SWEP.Purpose			= ""
SWEP.Instructions			= ""

SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound		= Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil		= 10
SWEP.Primary.Damage		= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.NumAmmo		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay 		= 0
SWEP.Primary.SuppressorSound = ""
SWEP.Primary.NoSuppressorSound = ""

SWEP.Primary.ClipSize		= 5					// Size of a clip
SWEP.Primary.DefaultClip	= 5					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.MeleeRange				= 70

SWEP.ActionDelay			= CurTime()
SWEP.ShootingLastTime		= CurTime()
SWEP.ReloadTime 			= -1

SWEP.FireChance 			= -1

// I added this function because some weapons like the Day of Defeat weapons need 1.2 or 1.5 seconds to deploy
SWEP.DeployDelay			= 1

// Is it a pistol, a rifle, a shotgun or a sniper? Choose only one of them or you'll fucked up everything. BITCH!
SWEP.Pistol				= false
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.IronSightsPos 		= Vector (0, 0, 0)
SWEP.IronSightsAng 		= Vector (0, 0, 0)

SWEP.RunArmOffset 		= Vector (0, 0, 5.5)
SWEP.RunArmAngle 			= Vector (-35, -3, 0)

SWEP.HoldingPos 		= Vector(0,0,0)
SWEP.HoldingAng 		= Vector(0,0,0)

// Burst options
SWEP.Burst				= false
SWEP.BurstShots			= 3
SWEP.BurstDelay			= 0.05
SWEP.BurstCounter			= 0
SWEP.BurstTimer			= 0

// Custom mode options (Do not put a burst mode and a custom mode at the same time, it will not work)
SWEP.Type				= 1 					// 1 = Automatic/Semi-Automatic mode, 2 = Suppressor mode, 3 = Burst fire mode
SWEP.Mode				= false

SWEP.data 				= {}
SWEP.data.NormalMsg		= "Switched to semi-automatic."
SWEP.data.ModeMsg			= "Switched to automatic."
SWEP.data.Delay			= 0.5 				// You need to wait 0.5 second after you change the fire mode
SWEP.data.Cone			= 1
SWEP.data.Damage			= 1
SWEP.data.Recoil			= 1
SWEP.data.Automatic		= false

// Constant accuracy means that your crosshair will not change if you're running, shooting or walking
SWEP.ConstantAccuracy		= false

// I don't think it's hard to understand this
SWEP.Penetration			= false
SWEP.MinPenetration			= -1
SWEP.PenetrationDmgMult		= -1
SWEP.Ricochet				= true
SWEP.MaxRicochet			= 1
SWEP.ChainHit				= 3
SWEP.SuperRicochet			= false
SWEP.ExplosiveShot			= false

SWEP.IdleDelay			= 0
SWEP.IdleApply			= false
SWEP.AllowIdleAnimation		= true
SWEP.AllowPlaybackRate		= true

SWEP.BoltActionSniper		= false				// Use this value if you want to remove the scope view after you shoot
SWEP.DualAction 			= false
SWEP.ScopeAfterShoot		= false				// Do not try to change this value

SWEP.IronSightZoom 		= 1.5
SWEP.ScopeZooms			= {5}
SWEP.ScopeScale 			= 0.4

SWEP.ShotgunReloading		= false
SWEP.ShotgunFinish		= 0.5
SWEP.ShotgunBeginReload		= 0.3

SWEP.EmptyReload			= false

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
	Pos = {
		Up = 0,
		Right = 0,
		Forward = 0
	},
	Ang = {
		Up = 0,
		Right = 0,
		Forward = 0
	},
	Scale = 1
}

/*---------------------------------------------------------
Muzzle Effect + Shell Effect
---------------------------------------------------------*/
SWEP.MuzzleEffect			= "rg_muzzle_pistol" -- This is an extra muzzleflash effect
-- Available muzzle effects: rg_muzzle_grenade, rg_muzzle_highcal, rg_muzzle_hmg, rg_muzzle_pistol, rg_muzzle_rifle, rg_muzzle_silenced, none

SWEP.ShellEffect			= "effect_mad_shell_pistol"	// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay				= 0
-- Available shell eject effects: rg_shelleject, rg_shelleject_rifle, rg_shelleject_shotgun, none

SWEP.MuzzleAttachment		= "1" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "2" -- Should be "2" for CSS models or "1" for hl2 models
/*---------------------------- ---------------------------*/

/*---------------------------------------------------------
   Name: SWEP:Initialize()
   Desc: Called when the weapon is first loaded.
---------------------------------------------------------*/
function SWEP:Initialize()
	if(self.Owner:IsNPC()) then
		self:SetWeaponHoldType("smg")
	else
		self:SetWeaponHoldType(self.HoldType)
	end
	
	self.Reloadaftershoot = 0 				-- Can't reload when firing
	self:SetWeaponHoldType(self.HoldType)
	self.Weapon:SetNetworkedBool("Reloading", false)

	PrecacheParticleSystem("smoke_trail")
	
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
		
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
end

/*---------------------------------------------------------
   Name: ENT:SetupDataTables()
   Desc: Setup the data tables.
---------------------------------------------------------*/
function SWEP:SetupDataTables()  // zDark.com - Fix - 19 August 2010

	self:DTVar("Bool", 0, "Holsted")
	self:DTVar("Bool", 1, "Ironsights")
	self:DTVar("Bool", 2, "Scope")
	self:DTVar("Bool", 3, "Mode")
	
end 

/*---------------------------------------------------------
   Name: SWEP:Proficiency()
   Desc: For NPCs using these weapons somehow
---------------------------------------------------------*/
function SWEP:Proficiency()
	if CLIENT then return end
	if !self:IsValid() or !self.Owner:IsValid() then return end
	if not self.Owner:IsNPC() then return end
	
	self:SetWeaponHoldType(self.HoldType)
	self:SetHoldType(self.HoldType)
	
	if self.Owner:GetClass() == "npc_combine_s" then
		self.Owner:SetCurrentWeaponProficiency(2)
		if self.Owner:GetMaxHealth() >= 65 then 
			self.Owner:SetCurrentWeaponProficiency(4) 
		end
	elseif self.Owner:GetClass() == "npc_citizen" then
		self.Owner:SetCurrentWeaponProficiency(1)
	elseif self.Owner:GetClass() == "npc_metropolice" then
		self.Owner:SetCurrentWeaponProficiency(1)
	elseif self.Owner:GetClass() == "npc_monk" then
		self.Owner:SetCurrentWeaponProficiency(4)
	elseif self.Owner:GetClass() == "npc_alyx" or self.Owner:GetClass() == "npc_barney" then
		self.Owner:SetCurrentWeaponProficiency(4)
	else
		self.Owner:SetCurrentWeaponProficiency(0)
	end
end

/*---------------------------------------------------------
   Name: SWEP:ResetVariables()
   Desc: Reset all varibles.
---------------------------------------------------------*/
function SWEP:ResetVariables()
	
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack()
   Desc: +attack1 has been pressed.
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	-- Holst/Deploy your fucking weapon
	if (not self.Owner:IsNPC() and self.Owner:KeyDown(IN_USE)) then
		bHolsted = !self.Weapon:GetDTBool(0)
		self:SetHolsted(bHolsted)

		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)

		self:SetIronsights(false)

		return
	end

	if (not self:CanPrimaryAttack()) then 
		if self.Weapon:Clip1() == 0 then self:Reload() end
		return 
	end

	self.ActionDelay = (CurTime() + self.Primary.Delay + 0.05)
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	-- If the burst mode is activated, it's going to shoot the three bullets (or more if you're dumb and put 4 or 5 bullets for your burst mode)
	if self.Weapon:GetDTBool(3) and self.Type == 3 then
		self.BurstTimer 	= CurTime()
		self.BurstCounter = self.BurstShots - 1
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
	end

	self.Weapon:EmitSound(self.Primary.Sound, 75, 100, 1, CHAN_AUTO)

	if not self.Owner:IsNPC() then
		self:ShootAnimation()
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)				-- 3rd Person Animation

	self:TakePrimaryAmmo(self.Primary.NumAmmo)
	
	self:ShootBulletInformation()
	
	if (not self.Owner:IsNPC()) and ( self.BoltActionSniper or self.DualAction ) and self.Weapon:GetDTBool(1) then
		self:SetIronsights(false)
		self:ResetVariables()

		timer.Simple(self.Primary.Delay, function()
			if not self.Owner then return end
			if (self.Weapon:Clip1() > 0) then
				self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
				self.Weapon:SetNextSecondaryFire(CurTime() + 0.2)
				self:SetIronsights(true)
			end
		end)
	end
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if self.Owner:IsNPC() then return end
	if not IsFirstTimePredicted() then return end

	if (self.Owner:KeyDown(IN_USE) and (self.Mode)) then // Mode
		bMode = !self.Weapon:GetDTBool(3)
		self:SetMode(bMode)
		self:SetIronsights(false)

		self.Weapon:SetNextPrimaryFire(CurTime() + self.data.Delay)
		self.Weapon:SetNextSecondaryFire(CurTime() + self.data.Delay)

		return
	end

	if (!self.IronSightsPos) or (self.Owner:KeyDown(IN_SPEED) or self.Weapon:GetDTBool(0)) then return end
	
	// Not pressing Use + Right click? Ironsights
	bIronsights = !self.Weapon:GetDTBool(1)
	self:SetIronsights(bIronsights)

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.2)
end

/*---------------------------------------------------------
   Name: SWEP:SetHolsted()
---------------------------------------------------------*/
function SWEP:SetHolsted(b)

	if (self.Owner) then
		if (b) then
			self.Weapon:EmitSound("weapons/universal/iron_in.wav")
		else
			self.Weapon:EmitSound("weapons/universal/iron_out.wav")
		end
	end

	if (self.Weapon) then
		self.Weapon:SetDTBool(0, b)
	end
end

/*---------------------------------------------------------
   Name: SWEP:SetIronsights()
---------------------------------------------------------*/
function SWEP:SetIronsights(b)

	if (self.Owner:IsValid()) then
		if (b) then
			if (SERVER) then
				self.Owner:SetFOV(65, 0.2)
			end

			self.Weapon:EmitSound("weapons/universal/iron_in.wav")
		else
			if (SERVER) then
				self.Owner:SetFOV(0, 0.2)
			end

			self.Weapon:EmitSound("weapons/universal/iron_out.wav")
		end
	end

	if (self.Weapon) then
		self.Weapon:SetDTBool(1, b)
	end
end

/*---------------------------------------------------------
   Name: SWEP:SetMode()
---------------------------------------------------------*/
function SWEP:SetMode(b)

	if (self.Weapon) then
		self.Weapon:SetDTBool(3, b)
	end

	if (!self.Owner) then return end
	
	if (b) then
		if self.Type == 1 then
			self.Primary.Automatic = self.data.Automatic
			self.Weapon:EmitSound("weapons/smg1/switch_burst.wav")
		elseif self.Type == 2 then
			self.Weapon:SendWeaponAnim(ACT_VM_ATTACH_SILENCER)
			self.Primary.Sound = Sound(self.Primary.SuppressorSound)
		elseif self.Type == 3 then
			self.Weapon:EmitSound("weapons/smg1/switch_burst.wav")
		end

		if (SERVER) then
			self.Owner:PrintMessage(HUD_PRINTTALK, self.data.ModeMsg)
		end
	else
		if self.Type == 1 then
			self.Primary.Automatic = !self.data.Automatic
			self.Weapon:EmitSound("weapons/smg1/switch_single.wav")
		elseif self.Type == 2 then
			self.Weapon:SendWeaponAnim(ACT_VM_DETACH_SILENCER)
			self.Primary.Sound = Sound(self.Primary.NoSuppressorSound)
		elseif self.Type == 3 then
			// Nothing here for the burst fire mode
			self.Weapon:EmitSound("weapons/smg1/switch_single.wav")
		end

		if (SERVER and self.Owner:IsValid()) then
			self.Owner:PrintMessage(HUD_PRINTTALK, self.data.NormalMsg)
		end
	end
end

/*---------------------------------------------------------
   Name: SWEP:CheckReload()
   Desc: CheckReload.
---------------------------------------------------------*/
function SWEP:CheckReload()
end

/*---------------------------------------------------------
   Name: SWEP:Reload()
   Desc: Reload is being pressed.
---------------------------------------------------------*/
function SWEP:Reload()

	if (self.ReloadTime > 0 ) then
		self:SpecialReload()
		return
	end

	// When the weapon is already doing an animation, just return end because we don't want to interrupt it
	if (self.ActionDelay > CurTime()) then return end 
	
	if (self.Weapon:Clip1() < self.Primary.ClipSize) and (self.Owner:GetAmmoCount(self:GetPrimaryAmmoType()) > 0) then
		self:SetIronsights(false)
		self:ResetVariables()
		self:ReloadAnimation()
		self:MagazineDrop()
		self:ReloadSounds()
		if SERVER then
			self.Owner:SetAnimation(PLAYER_RELOAD)	
		end
	else
		self:WeaponFidget()
	end
end

/*---------------------------------------------------------
   Name: SWEP:WeaponFidget()
   Desc: Reload is being pressed when there is no need to reload
---------------------------------------------------------*/
function SWEP:WeaponFidget()
	if not IsFirstTimePredicted() then return end
	if not self.Owner:KeyPressed(IN_RELOAD) then return end
	if not self.ApplyIdle then return end
	self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
end

/*---------------------------------------------------------
   Name: SWEP:ReloadSounds()
   Desc: Just in case a weapon doesn't have specific sounds binded to its viewmodel
---------------------------------------------------------*/
function SWEP:ReloadSounds()

end

/*---------------------------------------------------------
   Name: SWEP:SpecialReload()
   Desc: Reload is being pressed but with a specified time
---------------------------------------------------------*/
function SWEP:SpecialReload()

	-- When the weapon is already doing an animation, just return end because we don't want to interrupt it
	if (self.ActionDelay > CurTime()) then return end 
	
	if (self.Weapon:GetNWBool("Reloading")) then return end

	if (self.Weapon:Clip1() < self.Primary.ClipSize) and (self.Owner:GetAmmoCount(self:GetPrimaryAmmoType()) > 0) then
		self:SetIronsights(false)
		self:ResetVariables()
		self:SpecialReloadAnimation()
		local speedMult = self.Owner:GetViewModel():GetPlaybackRate()
		self.Weapon:SetNetworkedInt("ReloadTime", CurTime() + self.ReloadTime / speedMult)
		self.Weapon:SetNetworkedBool("Reloading", true)
		self.ActionDelay = (CurTime() + self.ReloadTime / speedMult + 0.05)
		self.Weapon:SetNextPrimaryFire(CurTime() + self.ReloadTime / speedMult + 0.1)
		self.Weapon:SetNextSecondaryFire(CurTime() + self.ReloadTime / speedMult + 0.1)
		self:MagazineDrop()
		self:ReloadSounds()
		if SERVER then
			self.Owner:SetAnimation(PLAYER_RELOAD)	
		end
	else
		self:WeaponFidget()
	end
	
end

/*---------------------------------------------------------
   Name: SWEP:MagazineDrop()
   Desc: Omitting for now because nothing has a magazine
---------------------------------------------------------*/
function SWEP:MagazineDrop() 

end

/*---------------------------------------------------------
   Name: SWEP:ReloadAnimation()
---------------------------------------------------------*/
function SWEP:ReloadAnimation()

	// Reload with the suppressor animation if you're suppressor is on the FUCKING gun
	if self.Weapon:GetDTBool(3) and self.Type == 2 then
		self.Weapon:DefaultReload(ACT_VM_RELOAD_SILENCED)
	else
		self.Weapon:DefaultReload(ACT_VM_RELOAD)
	end
end
/*---------------------------------------------------------
   Name: SWEP:ReloadAnimation()
---------------------------------------------------------*/
function SWEP:SpecialReloadAnimation()
	if self.Weapon:GetDTBool(3) and self.Type == 2 then
		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD_SILENCED)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
	end
end

/*---------------------------------------------------------
   Name: SWEP:IdleThink()
   Desc: New idle system based on whether the current 
		played sequence is finished 
---------------------------------------------------------*/
SWEP.ApplyIdle = true
SWEP.ApplyIdleTime = 1
SWEP.ApplyIdleCurTime = CurTime()

function SWEP:IdleThink()
	if not self.ApplyIdle then return end
	if not self.AllowIdleAnimation then return end
	if self.ApplyIdleCurTime > CurTime() then return end
	self.ApplyIdleCurTime = CurTime() + self.ApplyIdleTime
	
	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then
		if vm:IsSequenceFinished() then
			self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
		end
	end
end

/*---------------------------------------------------------
   Name: SWEP:AccuracyThink()
   Desc: New accuracy system to figure out weapon
		cone and recoil
---------------------------------------------------------*/
function SWEP:AccuracyThink()
	
	if self.SMG or self.Assault then
		self.TotalConeRemain = self.TotalConeRemain - (self.TotalConeRemain / 24) * (66 / (1 / engine.TickInterval()))
	elseif self.Rifle or self.Sniper then
		self.TotalConeRemain = self.TotalConeRemain - (self.TotalConeRemain / 84) * (66 / (1 / engine.TickInterval()))
	else
		self.TotalConeRemain = self.TotalConeRemain - (self.TotalConeRemain / 48) * (66 / (1 / engine.TickInterval()))
	end
	
	if self.TotalConeRemain < 0 then
		self.TotalConeRemain = 0
	end
	
	self.TotalRecoilRemain = self.TotalRecoilRemain - (self.TotalRecoilRemain / 8) * (66 / (1 / engine.TickInterval()))
	if self.TotalRecoilRemain < 0 then
		self.TotalRecoilRemain = 0
	end
	
	self:ConeCalculation()
end

/*---------------------------------------------------------
   Name: SWEP:SecondThink()
   Desc: Called every frame. Use this function if you don't 
	   want to copy/past the think function everytime you 
	   create a new weapon with this base...
---------------------------------------------------------*/
function SWEP:SecondThink()
end

/*---------------------------------------------------------
   Name: SWEP:SpecialReloadThink()
   Desc: Called every frame. Used to correct the reload
	   time on specially sequenced weapons
---------------------------------------------------------*/
function SWEP:SpecialReloadThink()
	if self.Weapon:GetNetworkedBool("Reloading") == true then
		if self.Weapon:GetNetworkedInt("ReloadTime") < CurTime() then
		
			self.Weapon:SetNetworkedBool("Reloading", false)
			local ammo = self.Owner:GetAmmoCount( self:GetPrimaryAmmoType() )
			ammo = ammo - ( self.Primary.ClipSize - self.Weapon:Clip1() )
			self.Owner:RemoveAmmo(self.Primary.ClipSize - self.Weapon:Clip1(), self:GetPrimaryAmmoType(), false)
			if ammo >= 0 then
				self.Weapon:SetClip1(self.Primary.ClipSize)
			else
				self.Weapon:SetClip1(self.Primary.ClipSize + ammo)
			end
		end
	end
end

/*---------------------------------------------------------
   Name: SWEP:Think()
   Desc: Called every frame.
---------------------------------------------------------*/
function SWEP:Think()

	self:SecondThink()
	self:IdleThink()
	self:AccuracyThink()

	if self.Owner:GetVelocity():Length() > 350 or self.Weapon:GetDTBool(0) then
		
		if self.HoldType == "smg" or self.HoldType == "ar2" or self.HoldType == "crossbow"
		or self.HoldType == "shotgun" then
			if ( self.Owner:Crouching() and self.Owner:GetVelocity():Length() == 0 ) then
				self:SetWeaponHoldType( 'normal' )
				self:SetHoldType( 'normal' )
			else
				self:SetWeaponHoldType( 'passive' )
				self:SetHoldType( 'passive' )
			end
		else
			self:SetWeaponHoldType( 'normal' )
			self:SetHoldType( 'normal' )
		end
		
	else
		self:SetWeaponHoldType(self.HoldType)
		self:SetHoldType(self.HoldType)
	end
	
	if( self.ReloadTime > 0 ) then
		self:SpecialReloadThink()
	end

	if self.Weapon:Clip1() > 0 and self.IdleDelay < CurTime() and self.IdleApply then
		local WeaponModel = self.Weapon:GetOwner():GetActiveWeapon():GetClass()

		if self.Owner and self.Weapon:GetOwner():GetActiveWeapon():GetClass() == WeaponModel and self.Owner:Alive() then
			if self.Weapon:GetDTBool(3) and self.Type == 2 then
				self.Weapon:SendWeaponAnim(ACT_VM_IDLE_SILENCED)
			else
				self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			end

			if self.AllowPlaybackRate and not self.Weapon:GetDTBool(1) then
				self.Owner:GetViewModel():SetPlaybackRate(1)
			else
				self.Owner:GetViewModel():SetPlaybackRate(0)
			end		
		end

		self.IdleApply = false
	elseif self.Weapon:Clip1() <= 0 then
		self.IdleApply = false
	end

	if self.Weapon:GetDTBool(1) and self.Owner:KeyDown(IN_SPEED) then
		self:SetIronsights(false)
	end

	// Burst fire mode
	if self.Weapon:GetDTBool(3) and self.Type == 3 then
		if self.BurstTimer + self.BurstDelay < CurTime() then
			if self.BurstCounter > 0 then
				self.BurstCounter = self.BurstCounter - 1
				self.BurstTimer = CurTime()
				
				if self:CanPrimaryAttack() then
					self.Weapon:EmitSound(self.Primary.Sound)
					self:ShootBulletInformation()
					self:TakePrimaryAmmo(1)
				end
			end
		end
	end
	
	self:NextThink(CurTime())
end

function SWEP:OnRemove()

	self:ResetVariables()
	
end

/*---------------------------------------------------------
   Name: SWEP:Holster()
   Desc: Weapon wants to holster.
	   Return true to allow the weapon to holster.
---------------------------------------------------------*/
function SWEP:Holster()

	self:OnRemove()
	return true
	
end

/*---------------------------------------------------------
   Name: SWEP:OnDrop()
   Desc: Weapon wants to be dropped.
---------------------------------------------------------*/
function SWEP:OnDrop()

	self:OnRemove()

end
/*---------------------------------------------------------
   Name: SWEP:Deploy()
   Desc: Whip it out.
---------------------------------------------------------*/
function SWEP:Deploy()

	self:SetWeaponHoldType(self.HoldType)
	self.Weapon:SetNetworkedBool("Reloading", false)
	self.Weapon:SetNWFloat(2, self.Primary.Cone)

	self:DeployAnimation()

	-- self.Weapon:SetNextPrimaryFire(CurTime() + self.DeployDelay + 0.05)
	-- self.Weapon:SetNextSecondaryFire(CurTime() + self.DeployDelay + 0.05)
	-- self.ActionDelay = (CurTime() + self.DeployDelay + 0.05)

	self:SetIronsights(false)
	

	return true
end

/*---------------------------------------------------------
   Name: SWEP:DeployAnimation()
---------------------------------------------------------*/
function SWEP:DeployAnimation()

	// Weapon has a suppressor
	if self.Weapon:GetDTBool(3) and self.Type == 2 then
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	end
end

/*---------------------------------------------------------
   Name: SWEP:CrosshairAccuracy()
   Desc: Crosshair informations.
---------------------------------------------------------*/
SWEP.SprayTime 		= 0.1
SWEP.SprayAccuracy 	= 0.2

function SWEP:CrosshairAccuracy()

	// Is it a constant accuracy weapon or is it a NPC? The NPC doesn't need a crosshair. Fuck him!
	if (self.ConstantAccuracy) or (self.Owner:IsNPC()) then
		return 1.0
	end
	
	local LastAccuracy 	= self.LastAccuracy or 0
	local Accuracy 		= 1.0
	local LastShoot 	= self.Weapon:GetNetworkedFloat("LastShootTime", 0)
	local Speed 		= self.Owner:GetVelocity():Length()

	local SpeedClamp = math.Clamp(math.abs(Speed / 705), 0, 1)
	
	if (CurTime() <= LastShoot + self.SprayTime) then
		Accuracy = Accuracy * self.SprayAccuracy
	end
	
	-- if (not self.Owner:IsOnGround()) then
		-- Accuracy = Accuracy * 0.1
	-- elseif (Speed > 10) then
		-- Accuracy = Accuracy * (((1 - SpeedClamp) + 0.1) / 2)
	-- end

	if (LastAccuracy != 0) then
		if (Accuracy > LastAccuracy) then
			Accuracy = math.Approach(self.LastAccuracy, Accuracy, FrameTime() * 2)
		else
			Accuracy = math.Approach(self.LastAccuracy, Accuracy, FrameTime() * -2)
		end
	end
	
	self.LastAccuracy = Accuracy
	return math.Clamp(Accuracy, 0.2, 1)
end

/*---------------------------------------------------------
   Name: SWEP:ShootBulletInformation()
   Desc: This function add the damage, the recoil, the number of shots and the cone on the bullet.
---------------------------------------------------------*/
SWEP.TotalConeRemain = 0
SWEP.TotalRecoilRemain = 0
SWEP.NextCone = 0

function SWEP:ShootBulletInformation()

	local CurrentDamage
	local CurrentRecoil
	local CurrentCone
	local ProjectedCone
	local NextConeUse = false

	if self.Weapon:GetDTBool(3) then
		CurrentDamage = self.Primary.Damage * self.data.Damage * DamageMul:GetFloat()
		CurrentRecoil = self.Primary.Recoil * self.data.Recoil * RecoilMul:GetFloat()
		CurrentCone = self.Primary.Cone * self.data.Cone
	else
		CurrentDamage = self.Primary.Damage * DamageMul:GetFloat()
		CurrentRecoil = self.Primary.Recoil * RecoilMul:GetFloat()
		CurrentCone = self.Primary.Cone
	end

	if self.Owner:IsNPC() then
		self:ShootBullet(CurrentDamage, CurrentRecoil, self.Primary.NumShots, self.Primary.Cone)
		return
	end

	// When we have collected some fuel, we do a lot of damage! >:D
	if self.Owner:GetNetworkedInt("Fuel") > 0 then
		CurrentDamage = CurrentDamage * 1.25
	end

	local accMult = 0.4
	local recoilMult = math.pow( self.Primary.Recoil, 0.5 )
	if self.Weapon:GetDTBool(2) or self.Weapon:GetDTBool(1) then 
		if CurTime() - self.ShootingLastTime < 0.2 * recoilMult then
			accMult = accMult * 2.5
		end
		CurrentCone = CurrentCone * 0.75
		accMult = accMult / 3.0
	else
		if CurTime() - self.ShootingLastTime < 0.5 * recoilMult then
			NextConeUse = true
			local ConeRemain = 0.5 * recoilMult - (CurTime() - self.ShootingLastTime)
			ConeRemain = math.Clamp(ConeRemain / 0.5 * recoilMult, 0, 1)
			self.TotalConeRemain = self.TotalConeRemain + ConeRemain
			self.TotalRecoilRemain = self.TotalRecoilRemain + ConeRemain
			CurrentCone = CurrentCone + (0.05 * recoilMult)*0.0 + (0.05 * recoilMult)*0.99*self.TotalConeRemain
			accMult = accMult * 1.5*0.0 + 1.5*0.99*self.TotalRecoilRemain
			if self.Shotgun then
				CurrentCone = CurrentCone - (0.05 * recoilMult)*0.0 - (0.05 * recoilMult)*0.99*self.TotalConeRemain
			end
		end
		
		if self.SMG then CurrentCone = CurrentCone * 1.1 end
		if self.Assault then CurrentCone = CurrentCone * 1.1 accMult = accMult * 1.1 end
		if self.Shotgun then accMult = accMult * 1.4 end
		if self.Rifle then 
			CurrentCone = CurrentCone * 1.2
			accMult = accMult * 1.4
		end
		if self.Sniper then 
			CurrentCone = CurrentCone * 1.3
			accMult = accMult * 1.4
		end
	end
	
	-- Restricting mobility is bad
	-- if self.Owner:KeyDown(IN_FORWARD || IN_BACK || IN_MOVELEFT || IN_MOVERIGHT) then 
		-- CurrentCone = CurrentCone * 1.25
		-- accMult = accMult * 1.5
	-- end
	-- if not self.Owner:IsOnGround() then 
		-- CurrentCone = CurrentCone + 0.05 * recoilMult
		-- accMult = accMult * 2
	-- end
	if self.Owner:Crouching() then 
		CurrentCone = CurrentCone * 0.85
		accMult = accMult / 2.0 
	end
	
	self.ShootingLastTime = CurTime()
	--self.Weapon:SetNWFloat(2, CurrentCone)
	-- timer.Simple(0.5 * recoilMult, function() 
		-- if not IsValid( self.Weapon ) then return end
		-- if CurTime() - self.ShootingLastTime >= 0.5 * recoilMult - 0.05 then self.Weapon:SetNWFloat(2, self.Primary.Cone) end
	-- end )
	if NextConeUse then
		self:ShootBullet(CurrentDamage, CurrentRecoil * accMult, self.Primary.NumShots, self.NextCone)
		--self.NextCone = CurrentCone
	else
		--self.NextCone = CurrentCone
		self:ShootBullet(CurrentDamage, CurrentRecoil * accMult, self.Primary.NumShots, CurrentCone)
	end
	self.Owner:ViewPunch(Angle(math.Rand(-0.75, -1.0) * (CurrentRecoil * accMult) * 0.8, math.Rand(-1, 1) * (CurrentRecoil * accMult) * 0.4, math.Rand(-0.75, 0.75) * (CurrentRecoil * accMult) * 0.4))
	
end

function SWEP:ConeCalculation()
	if not IsFirstTimePredicted() then return end
	if SERVER or not game.SinglePlayer() then
		
		local CurrentCone = self.Primary.Cone
		local NextConeUse = false
		
		local recoilMult = math.pow( self.Primary.Recoil, 0.5 )
		if self.Weapon:GetDTBool(2) or self.Weapon:GetDTBool(1) then 
			if CurTime() - self.ShootingLastTime < 0.2 * recoilMult then
			
			end
			CurrentCone = CurrentCone * 0.75
		else
			--if CurTime() - self.ShootingLastTime < 0.5 * recoilMult then
				NextConeUse = true
				local ConeRemain = 0.5 * recoilMult - (CurTime() - self.ShootingLastTime)
				ConeRemain = math.Clamp(ConeRemain / 0.5 * recoilMult, 0, 1)
				CurrentCone = CurrentCone + (0.05 * recoilMult)*0.0 + (0.05 * recoilMult)*0.99*self.TotalConeRemain
				if self.Shotgun then
					CurrentCone = CurrentCone - (0.05 * recoilMult)*0.0 - (0.05 * recoilMult)*0.99*self.TotalConeRemain
				end
			--end
			
			if self.SMG then CurrentCone = CurrentCone * 1.1 end
			if self.Assault then CurrentCone = CurrentCone * 1.1 end
			if self.Shotgun then end
			if self.Rifle then 
				CurrentCone = CurrentCone * 1.2
			end
			if self.Sniper then 
				CurrentCone = CurrentCone * 1.3
			end
		end
		if self.Owner:Crouching() then 
			CurrentCone = CurrentCone * 0.85
		end
		if NextConeUse then
			if SERVER then
				self.Weapon:SetNWFloat(2, self.NextCone)
			end
			self.NextCone = CurrentCone
		else
			self.NextCone = CurrentCone
			if SERVER then
				self.Weapon:SetNWFloat(2, CurrentCone)
			end
		end
	end
end

/*---------------------------------------------------------
   Name: SWEP:ShootEffects()
   Desc: A convenience function to shoot effects.
---------------------------------------------------------*/
function SWEP:ShootEffects()
	
	self.Owner:MuzzleFlash()

	if self.Owner:IsNPC() then return end

	local Vm = self.Owner:GetViewModel()
	if Vm == nil then return end
	
	timer.Create("SmokeTrail",1,1,function()
		ParticleEffectAttach( "smoke_trail", PATTACH_POINT_FOLLOW , 
		Vm, Vm:LookupAttachment( "1" )) 
		ParticleEffectAttach( "smoke_trail", PATTACH_POINT_FOLLOW , 
		Vm, Vm:LookupAttachment( "2" )) 
	end)

	--[[
	-- Shell eject
	timer.Simple(self.ShellDelay, function()
		if not self.Owner then return end
		if not IsValid(self.Owner) then return end
		if not IsFirstTimePredicted() then return end
		if not self.Owner:IsNPC() and not self.Owner:Alive() then return end
		
		local effectdata = EffectData()
		effectdata:SetEntity(self.Weapon)
		effectdata:SetNormal(self.Owner:GetAimVector())
		effectdata:SetAttachment(2)
		util.Effect(self.ShellEffect, effectdata)
	end)
	--]]

	if ((game.SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
	
end

/*---------------------------------------------------------
   Name: SWEP:ShootFire()
   Desc: Shoot fire bullets.
---------------------------------------------------------*/
function SWEP:ShootFire(attacker, tr, dmginfo)

	util.Decal("FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)

	local random = (1 / self.Primary.Delay) * (self.Primary.NumShots * (self.Primary.NumShots / 4))
	
	local outof = 1
	local chance = math.random(0, random)
	if self.FireChance >= 0 then
		outof = self.FireChance * 1000
		chance = math.random(0, 1000)
	end

	if chance < outof then
		if tr.Entity:GetPhysicsObject():IsValid() and not tr.Entity:IsPlayer() then
			tr.Entity:Ignite(math.random(5, 20), 0)

			local tracedata = {}
			tracedata.start = tr.HitPos
			tracedata.endpos = Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z - 10)
			tracedata.filter = tr.HitPos
			local tracedata = util.TraceLine(tracedata)

			if tracedata.HitWorld then
				if vFireInstalled then
					CreateVFire(game.GetWorld(), tr.HitPos, tr.HitNormal, 70, self)
				else
					local fire = ents.Create("env_fire")
					fire:SetPos(tr.HitPos)
					fire:SetKeyValue("health", math.random(5, 15))
					fire:SetKeyValue("firesize", "20")
					fire:SetKeyValue("fireattack", "10")
					fire:SetKeyValue("damagescale", "1.0")
					fire:SetKeyValue("StartDisabled", "0")
					fire:SetKeyValue("firetype", "0")
					fire:SetKeyValue("spawnflags", "128")
					fire:Spawn()
					fire:Fire("StartFire", "", 0)
				end
			end
		end
	end
end

/*---------------------------------------------------------
   Name: SWEP:ShootAnimation()
---------------------------------------------------------*/
function SWEP:ShootAnimation()

	// Too lazy to create a table :)
	local AllowDryFire = self.Owner:GetActiveWeapon():GetClass() == ("weapon_mad_deagle") 
				   or self.Owner:GetActiveWeapon():GetClass() == ("weapon_mad_usp") 

	if (self.Weapon:Clip1() <= 0) then
		if (AllowDryFire) then
			if self.Weapon:GetDTBool(3) and self.Type == 2 then
				self.Weapon:SendWeaponAnim(ACT_VM_DRYFIRE_SILENCED)	// View model animation
			else
				self.Weapon:SendWeaponAnim(ACT_VM_DRYFIRE) 		// View model animation
			end
		elseif self.Weapon:GetDTBool(3) and self.Type == 2 then
			self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SILENCED) 	// View model animation
		else
			self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK) 		// View model animation
		end
	else
		if self.Weapon:GetDTBool(3) and self.Type == 2 then
			self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SILENCED) 	// View model animation
		else
			self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK) 		// View model animation
		end
	end
end

/*---------------------------------------------------------
   Name: SWEP:FireShot()
   Desc: A convenience function to call ShootFire
---------------------------------------------------------*/
function SWEP:FireShot(attacker, tr, dmginfo) 
	if not self.Owner:IsNPC() and self.Owner:GetNetworkedInt("Fuel") > 0 then
		self.Owner:SetNetworkedInt("Fuel", math.Clamp(self.Owner:GetNetworkedInt("Fuel") - (math.random(1, 3) / self.Primary.NumShots), 0, 100))
		self:ShootFire(attacker, tr, dmginfo) 
	end
end
function SWEP:FireShotCallback(attacker, tr, dmginfo) 
	if false then
		self:ShootFire(attacker, tr, dmginfo) 
	end
end

/*---------------------------------------------------------
   Name: SWEP:ShootBullet()
   Desc: A convenience function to shoot bullets.
---------------------------------------------------------*/
SWEP.TracerName = "Tracer"
SWEP.DamageType = DMG_BULLET

function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone)

	num_bullets 		= num_bullets or 1
	aimcone 			= aimcone or 0

	self:ShootEffects()
	
	if self.Owner:IsNPC() then
		self:Proficiency()
		aimcone = aimcone * ( 1 - self.Owner:GetCurrentWeaponProficiency() * 0.2 )
	end
	
	local bullet = {}
		bullet.Num 		= num_bullets
		bullet.Src 		= self.Owner:GetShootPos()			// Source
		bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
		bullet.Spread 	= Vector(aimcone, aimcone, 0)		// Aim Cone
		bullet.Tracer	= 1						// Show a tracer on every x bullets
		bullet.TracerName = self.TracerName
		bullet.Force	= damage * 0.1						// Amount of force to give to phys objects
		bullet.Damage	= damage
		bullet.Callback	= function(attacker, tr, dmginfo) 
			dmginfo:SetDamageType( self.DamageType )
			self:FireShot(attacker, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetOrigin(tr.HitPos)
				effectdata:SetNormal(tr.HitNormal)
				effectdata:SetRadius(tr.MatType)
				effectdata:SetScale(1)
			return self:RicochetCallback_Redirect(attacker, tr, dmginfo) 
		end
	self.Owner:FireBullets(bullet)

	// Recoil
	if (not self.Owner:IsNPC()) and ((game.SinglePlayer() and SERVER) or (not game.SinglePlayer() and CLIENT)) then
		local eyeangle 	= self.Owner:EyeAngles()
		eyeangle.pitch 	= eyeangle.pitch - recoil * 1.4
		--eyeangle.yaw = eyeangle.yaw + math.random( recoil * -0.1, recoil * 0.1)
		self.Owner:SetEyeAngles(eyeangle)
	end
	
end

/*---------------------------------------------------------
   Name: SWEP:BulletPenetrate()
---------------------------------------------------------*/
function SWEP:BulletPenetrate(bouncenum, attacker, tr, dmginfo, isplayer)

	if (CLIENT) then return end

	local MaxPenetration

	if self.Primary.Ammo == "Pistol" then
		MaxPenetration = 150
	elseif self.Primary.Ammo == "smg1" then
		MaxPenetration = 120
	elseif self.Primary.Ammo == "buckshot" then
		MaxPenetration = 70
	elseif self.Primary.Ammo == "AR2" then
		MaxPenetration = 200
	elseif self.Primary.Ammo == "357" then
		MaxPenetration = 400
	elseif self.Primary.Ammo == "XBowBolt" then
		MaxPenetration = 500
	else
		MaxPenetration = 150
	end
	
	if self.MinPenetration >= 0 and MaxPenetration < self.MinPenetration then
		MaxPenetration = self.MinPenetration
	end
		
	local DoDefaultEffect = true
	// Don't go through metal, sand or player
	if ((tr.MatType == MAT_METAL and self.Ricochet) or (tr.MatType == MAT_SAND) or (tr.Entity:IsPlayer())) then return false end

	// Don't go through more than 3 times
	if (bouncenum > self.ChainHit) then return false end
	
	local penet = 0
	local successful = false
	local traceResult = {}
	for i=1, MaxPenetration / 50 do
		penet = penet + 50
		if not successful then
			-- Direction (and length) that we are going to penetrate
			local PenetrationDirection = tr.Normal * penet
			if (tr.MatType == MAT_GLASS or tr.MatType == MAT_PLASTIC or tr.MatType == MAT_WOOD or tr.MatType == MAT_FLESH or tr.MatType == MAT_ALIENFLESH) then
				PenetrationDirection = tr.Normal * (penet * 2)
			end
				
			local trace 	= {}
				trace.start 	= tr.HitPos + PenetrationDirection
				trace.endpos 	= tr.HitPos
				trace.mask 		= MASK_SHOT
				trace.collisiongroup = COLLISION_GROUP_PROJECTILE
				trace.filter 	= function( ent )
					return ent == tr.Entity
				end
			traceResult = util.TraceLine(trace) 
			
			if not IsValid( tr.Entity ) and not tr.Entity:IsWorld() then 
				traceResult.HitPos = tr.HitPos
				successful = true
				continue
			end
			if traceResult.Entity == nil then continue end
			-- Bullet didn't penetrate.
			if traceResult.StartSolid or traceResult.Fraction >= 1.0 then 
				continue
			end
		end
		successful = true
		break
	end
	if not successful then return false end
	
	// Damage multiplier depending on surface
	local fDamageMulti = 0.5
	
	if fDamageMulti < self.PenetrationDmgMult then
		fDamageMulti = self.PenetrationDmgMult
	end
	
	if (tr.MatType == MAT_CONCRETE) then
		fDamageMulti = fDamageMulti - 0.2
	elseif (tr.MatType == MAT_WOOD or tr.MatType == MAT_PLASTIC or tr.MatType == MAT_GLASS) then
		fDamageMulti = fDamageMulti + 0.3
	elseif (tr.MatType == MAT_FLESH or tr.MatType == MAT_ALIENFLESH) then
		fDamageMulti = fDamageMulti + 0.4
	end
	
	if fDamageMulti > 0.95 then
		fDamageMulti = 0.95;
	end
		
	// Fire bullet from the exit point using the original trajectory
	local bullet = 
	{	
		Num 		= 1,
		Src 		= traceResult.HitPos,
		Dir 		= tr.Normal,	
		Spread 		= Vector(0, 0, 0),
		Tracer		= 1,
		TracerName 	= "effect_mad_penetration_trace",
		Force		= (dmginfo:GetDamage() * fDamageMulti) * 0.5,
		Damage		= (dmginfo:GetDamage() * fDamageMulti),
		HullSize	= 2,
		IgnoreEntity = tr.Entity
	}
	
	bullet.Callback   = function(a, b, c) 
		if (self.Ricochet) then
			return self:RicochetCallback(bouncenum + 1, a, b, c) 
		end 
	end
	
	timer.Simple(0.01, function()
		if not IsFirstTimePredicted() then return end
		attacker.FireBullets(attacker, bullet, true)
	end)

	return true
end

/*---------------------------------------------------------
   Name: SWEP:RicochetCallback()
---------------------------------------------------------*/
function SWEP:RicochetCallback(bouncenum, attacker, tr, dmginfo)

	if CLIENT then return end
	if not self then return end
	if not IsValid( self ) then return end
	if tr.HitSky then return end
	
	if tr.Entity:GetClass() == "npc_sniper" and self.Sniper then
		util.BlastDamage( tr.Entity, tr.Entity, tr.HitPos, 75, 100 )
		return
	end

	if self.ExplosiveShot then
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetScale(1)
		util.Effect("cball_explode", effectdata)
		util.Effect("Explosion", effectdata)
		util.BlastDamage(self, attacker, tr.HitPos, 75, dmginfo:GetDamage())
		return
	end
	
	self:FireShotCallback(attacker, tr, dmginfo)
	
	-- Can we go through whatever we hit?
	if self.Penetration and self:BulletPenetrate(bouncenum, attacker, tr, dmginfo) then
		return {damage = true, effects = true}
	end
	
	// Your screen will shake and you'll hear the savage hiss of an approaching bullet which passing if someone is shooting at you.
	if tr.MatType != MAT_METAL then
		-- Too expensive
		-- if (SERVER) then
			-- util.ScreenShake(tr.HitPos, 5, 0.1, 0.5, 64)
			-- sound.Play("Bullets.DefaultNearmiss", tr.HitPos, 250, math.random(110, 180), 1)
		-- end
		return 
	end

	if (self.Ricochet == false) then return {damage = true, effects = true} end
	
	if (bouncenum > self.MaxRicochet) then return end
	
	// Bounce vector
	local trace = {}
	trace.start = tr.HitPos
	trace.endpos = trace.start + (tr.HitNormal * 16384)

	local trace = util.TraceLine(trace)

 	local DotProduct = tr.HitNormal:Dot(tr.Normal * -1) 
	
	local bullet = 
	{	
		Num 		= 1,
		Src 		= tr.HitPos + (tr.HitNormal * 5),
		Dir 		= ((2 * tr.HitNormal * DotProduct) + tr.Normal) + (VectorRand() * 0.05),
		Spread 		= Vector(0, 0, 0),
		Tracer		= 1,
		TracerName 	= "effect_mad_ricochet_trace",
		Force		= dmginfo:GetDamage() * 0.25,
		Damage		= dmginfo:GetDamage() * 0.5,
		HullSize	= 2
	}
		
	// Added conditional to stop errors when bullets ricochet after weapon switch
	bullet.Callback = function(a, b, c) 
		if (self.Ricochet) then 
			return self:RicochetCallback(bouncenum + 1, a, b, c) 
		end 
	end

	timer.Simple(0.01, function()
		if not IsFirstTimePredicted() then return end
		attacker.FireBullets(attacker, bullet, true)
	end)
	
	return {damage = true, effects = DoDefaultEffect}
end

/*---------------------------------------------------------
   Name: SWEP:RicochetCallback_Redirect()
---------------------------------------------------------*/
function SWEP:RicochetCallback_Redirect(a, b, c)
 
	return self:RicochetCallback(0, a, b, c) 
end

function SWEP:Graze( target, dmg )

end

function SWEP:Parry( target, dmg )

end

/*---------------------------------------------------------
   Name: SWEP:CanPrimaryAttack()
   Desc: Helper function for checking for no ammo.
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()

	// Clip is empty or you're under water
	if (self.Weapon:Clip1() <= 0) or (self.Owner:WaterLevel() > 2) then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
//		self.Weapon:EmitSound("Default.ClipEmpty_Pistol")
		return false
	end

	// You're sprinting or your weapon is holsted
	if not self.Owner:IsNPC() and (self.Owner:KeyDown(IN_SPEED) or self.Weapon:GetDTBool(0) or self.Owner:WaterLevel() > 2) then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		return false
	end

	return true
end

/*---------------------------------------------------------
   Name: SWEP:CanSecondaryAttack()
   Desc: Helper function for checking for no ammo.
---------------------------------------------------------*/
function SWEP:CanSecondaryAttack()

	// Clip is empty or you're under water
	if (self.Weapon:Clip2() <= 0) then
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
//		self.Weapon:EmitSound("Default.ClipEmpty_Pistol")
		return false
	end

	// You're sprinting or your weapon is holsted
	if not self.Owner:IsNPC() and (self.Owner:KeyDown(IN_SPEED) or self.Weapon:GetDTBool(0) or self.Owner:WaterLevel() > 2) then
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		return false
	end

	return true
end

function SWEP:DrawWorldModel()

	local hand, offset, rotate

	if not IsValid(self.Owner) then
		self:SetRenderOrigin( nil )
        self:SetRenderAngles( nil )
        self:DrawModel()
		return
	end

	hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))
	
	if hand == nil then
		self:SetRenderOrigin( nil )
        self:SetRenderAngles( nil )
		self:DrawModel()
		return
	end
	
	offset = hand.Ang:Right() * self.Offset.Pos.Right + hand.Ang:Forward() * self.Offset.Pos.Forward + hand.Ang:Up() * self.Offset.Pos.Up
	
	hand.Ang:RotateAroundAxis(hand.Ang:Right(), self.Offset.Ang.Right)
	hand.Ang:RotateAroundAxis(hand.Ang:Forward(), self.Offset.Ang.Forward)
	hand.Ang:RotateAroundAxis(hand.Ang:Up(), self.Offset.Ang.Up)
	
	self:SetRenderOrigin(hand.Pos + offset)
	self:SetRenderAngles(hand.Ang)

	self:DrawModel()

	if (CLIENT) then
		self:SetModelScale(self.Offset.Scale,self.Offset.Scale - 0.1,self.Offset.Scale)
	end
end

/*---------------------------------------------------------
   Name: SWEP:EntityFaceBack
   Desc: Is the entity face back to the player?
---------------------------------------------------------*/
function SWEP:EntsInSphereBack(pos, range)

	local ents = ents.FindInSphere(pos, range)

	for k, v in pairs(ents) do
		if v ~= self and v ~= self.Owner and (v:IsNPC() or v:IsPlayer()) and IsValid(v) and self:EntityFaceBack(v) then
			return true
		end
	end

	return false
end

/*---------------------------------------------------------
   Name: SWEP:EntityFaceBack
   Desc: Is the entity face back to the player?
---------------------------------------------------------*/
function SWEP:EntityFaceBack(ent)

	local angle = self.Owner:GetAngles().y - ent:GetAngles().y

	if angle < -180 then angle = 360 + angle end
	if angle <= 90 and angle >= -90 then return true end

	return false
end

/*---------------------------------------------------------
   Name: SWEP:EntityFaceFront
   Desc: Is the player face front to the entity?
---------------------------------------------------------*/
function SWEP:EntityFaceFront(ent, ang)

	local angle = self.Owner:EyeAngles().y - ( ent:GetPos() - self.Owner:GetPos() ):Angle().y
	
	if angle < -180 then angle = 360 + angle end
	if angle <= ang and angle >= -ang then return true end

	return false
end