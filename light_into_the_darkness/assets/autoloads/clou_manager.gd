extends Node

signal clou_collected(clou)

@export var identity_reward := 10

var collected_clous: Array[String] = []


func clear_data():
	collected_clous = []


func collect_clou(clou: Clou):
	if clou.collected:
		return
	
	clou.collected = true
	collected_clous.append(clou.data.clou_id)
	
	await DialogueManager.start_dialogue(clou.data.yarn_node)
	
	IdentityManager.add_progress(identity_reward)
	
	GameManager.player.mask_manager.add_charge(
		clou.data.boosted_mask,
		clou.data.mask_charge_reward
	)
	
	clou.hide()
	clou_collected.emit(clou)
