class_name DialogueState
extends BaseState


func enter(_owner):
	print("Dialog enter")
	GameManager.player.movement_state = Player.MovementState.IDLE
	GameManager.player.update_animation()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func exit():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	print("Dialog exit")
