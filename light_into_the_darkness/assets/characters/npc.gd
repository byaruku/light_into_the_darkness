class_name NPC
extends CharacterBody2D

@export var yarn_node: String
@export var yarn_node_after_memory: String
@export var memory: Portal.Destination

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

enum State {
	IDLE,
	RUN,
	DIALOG
}

var state:= State.IDLE


func _ready() -> void:
	DialogueManager.dialogue_runner.add_command("change_animation", change_animation)
	animation_tree.active = true
	change_animation("idle")


func interact() -> void:
	if state != State.IDLE:
		return
		
	state = State.DIALOG
	var node = yarn_node_after_memory if GameManager.memory_completed[memory] else yarn_node
	DialogueManager.start_dialogue(node)
	await DialogueManager.on_dialog_finished
	state = State.IDLE


func change_animation(animation_name: String):
	animation_playback.travel(animation_name)
