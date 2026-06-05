class_name MainMenuState
extends BaseState


func enter(_owner):
	print("MainMenu enter")
	IdentityManager.identity_bar.visible = false


func exit():
	print("MainMenu exit")
	IdentityManager.identity_bar.visible = true
