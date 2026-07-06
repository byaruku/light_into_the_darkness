extends Interactable

@onready var clou: Clou = get_parent()

func interact():
	if clou.collected:
		return
	
	DialogueManager.set_portrait(clou.data.icon)
	
	await ClouManager.collect_clou(clou)
