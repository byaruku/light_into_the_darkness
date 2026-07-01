class_name PauseState
extends BaseState

func enter(_owner):
	if GameManager.player:
		GameManager.player.pause_player()
	print("Pause enter")

func exit():
	if GameManager.player:
		GameManager.player.resume_player()
	print("Pause exit")
