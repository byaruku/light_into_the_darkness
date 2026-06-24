extends Interactable

@onready var clou: Clou = get_parent()

func interact():
	if clou.collected:
		return
	
	await ClouManager.collect_clou(clou)
