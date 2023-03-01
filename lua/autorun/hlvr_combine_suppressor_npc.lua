local Category = "Epic Sandbox Systems"

local NPC = {
	Name = "Combine Minigame", 
	Class = "npc_combine_s",
	KeyValues = { citizentype = 4 },
	Model = "models/hlvr/characters/combine/suppressor/combine_suppressor_hlvr_npc.mdl",
	Health = "250",
	Category = Category	
}

list.Set( "NPC", "npc_hlvr_suppressor_s", NPC )