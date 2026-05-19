class_name FreeRoamState
extends BaseState


var game_manager: GameManager


func enter(owner):
	game_manager = owner


func execute(delta):
	if game_manager.player == null:
		return
	
	game_manager.player.handle_update(delta)
