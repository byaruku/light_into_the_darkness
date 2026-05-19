class_name NPC
extends CharacterBody2D

@export var dialog: Dialog

enum State {
	IDLE,
	RUN,
	DIALOG
}

var state:= State.IDLE

func interact() -> void:
	if state != State.IDLE:
		return
		
	state = State.DIALOG
	await DialogManager.show_dialog(dialog)
	state = State.IDLE
