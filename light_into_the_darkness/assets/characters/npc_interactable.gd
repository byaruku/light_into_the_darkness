extends Interactable

@onready var npc: NPC = get_parent()

func interact():
	await npc.interact()
