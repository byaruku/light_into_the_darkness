class_name TriggerArea
extends Area2D

@export var node: String
@export var one_shot := true
@export var active := true
@export var has_collision := false

var triggered := false


func _ready() -> void:
	if has_collision:
		collision_layer = 1
	else:
		collision_layer = 0
	collision_mask = 0


func _on_body_entered(body: Node2D) -> void:
	if not active:
		return

	if triggered and one_shot:
		return

	if body is Player:
		triggered = true

		if node != "":
			DialogueManager.dialogue_runner.start_dialogue(node)
