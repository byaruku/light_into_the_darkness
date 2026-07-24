extends Interactable

@export var yarn_node: String
@export var mask: MaskAbility


func _ready() -> void:
	if str(mask.mask_type) in ClouManager.collected_clous:
		get_parent().queue_free()


func interact():
	GameManager.player.mask_manager.add_mask(mask)
	
	DialogueManager.start_dialogue(yarn_node)
	await DialogueManager.on_dialog_finished
	
	ClouManager.collected_clous.append(str(mask.mask_type))
	get_parent().queue_free()
