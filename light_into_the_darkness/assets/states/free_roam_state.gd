class_name FreeRoamState
extends BaseState


var game_manager: GameManager


func enter(owner):
	print("FreeRoam enter")
	game_manager = owner


func execute(delta):
	if game_manager.player == null:
		return
	
	game_manager.player.handle_update(delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		PauseManager.toggle_pause()


func exit():
	print("FreeRoam exit")
