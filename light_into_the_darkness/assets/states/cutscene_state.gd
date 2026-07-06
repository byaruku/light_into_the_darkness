class_name CutsceneState
extends BaseState

func enter(_owner):
	GameManager.player.start_cutscene()

func exit():
	GameManager.player.end_cutscene()
