extends Interactable

@export var yarn_node: String
@export var mask: MaskAbility


func _ready() -> void:
	if GameManager.memory_completed[Portal.Destination.TOWN]:
		get_parent().queue_free()


func interact():
	DialogueManager.start_dialogue(yarn_node)
	await DialogueManager.on_dialog_finished
	
	GameManager.player.mask_manager.add_mask(mask)
	get_parent().queue_free()
