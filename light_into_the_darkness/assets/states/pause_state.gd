class_name PauseState
extends BaseState

func enter(_owner):
	if GameManager.player:
		GameManager.player.movement_state = Player.MovementState.IDLE
		GameManager.player.update_animation()
	print("Pause enter")

func exit():
	if GameManager.player:
		GameManager.player.movement_state = Player.MovementState.IDLE
		GameManager.player.update_animation()
	print("Pause exit")
