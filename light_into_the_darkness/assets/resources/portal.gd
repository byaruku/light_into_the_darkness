class_name Portal
extends Area2D

enum Destination {
	TOWN,
	MEMORY_1,
	MEMORY_2,
	MEMORY_3
}

@export var portal_id: Destination
@export var target_portal_id: Destination
@export var spawn_marker: Marker2D


func _ready() -> void:
	add_to_group("portals")


func _on_body_entered(body):
	if body is Player:
		body.movement_state = Player.MovementState.IDLE
		body.update_animation()
		SceneManager.change_scene(target_portal_id)
