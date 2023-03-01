hook.Add( "OnNPCKilled", "SandboxMoneyOnKill", function(npc, attacker, inflictor)
	if !attacker:IsValid() or !attacker:IsPlayer() then return end
	
	SANDBOXMONEY.SandboxMoneyAddCurrency(attacker, math.ceil(npc:GetMaxHealth() / 50))
	
end)