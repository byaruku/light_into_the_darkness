class_name NPC
extends CharacterBody2D

@export var yarn_node: String

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
	await DialogueManager.start_dialogue(yarn_node)
	state = State.IDLE
