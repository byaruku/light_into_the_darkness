class_name CutsceneState
extends BaseState

func enter(_owner):
	GameManager.player.start_cutscene()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func exit():
	GameManager.player.end_cutscene()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
