class_name DialogueState
extends BaseState


func enter(_owner):
	print("Dialog enter")
	GameManager.player.movement_state = Player.MovementState.IDLE
	GameManager.player.update_animation()
	

func exit():
	print("Dialog exit")
