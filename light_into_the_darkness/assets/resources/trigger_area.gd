class_name TriggerArea
extends Area2D

@export var yarn_node: String
@export var one_shot := true
@export var active := true
@export var has_collision := false

var triggered := false


func _ready() -> void:
	if has_collision:
		$StaticBody2D/CollisionShape2D.disabled = false
	else:
		$StaticBody2D/CollisionShape2D.disabled = true
	collision_mask = 1


func _on_body_entered(body: Node2D) -> void:
	if not active:
		return

	if triggered and one_shot:
		return

	if body is Player:
		triggered = true

		if yarn_node != "":
			DialogueManager.start_dialogue(yarn_node)
			await DialogueManager.on_dialog_finished
