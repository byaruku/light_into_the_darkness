class_name MenuState
extends BaseState


func enter(_owner):
	print("MainMenu enter")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func exit():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	print("Menu exit")
