class_name FreeRoamState
extends BaseState


var game_manager: GameManager


func enter(owner):
	print("FreeRoam enter")
	game_manager = owner
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func execute(delta):
	if game_manager.player == null:
		return
	
	game_manager.player.handle_update(delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		AudioManager.play_ui_back()
		PauseManager.toggle_pause()


func exit():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	print("FreeRoam exit")
