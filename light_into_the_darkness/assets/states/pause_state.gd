class_name PauseState
extends BaseState

func enter(_owner):
	GameManager.player.pause_player()
	print("Pause enter")

func exit():
	GameManager.player.resume_player()
	print("Pause exit")
