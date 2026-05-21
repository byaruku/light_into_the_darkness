class_name Portal
extends Area2D

enum Destination {
	TOWN,
	DREAM
}

@export_file("*.tscn")
var target_scene: String

@export var portal_id: Destination
@export var target_portal_id: Destination
@export var spawn_marker: Marker2D


func _ready() -> void:
	add_to_group("portals")


func _on_body_entered(body):
	if body is Player:
		body.state = Player.State.IDLE
		body.update_animation()
		SceneManager.change_scene(target_scene, target_portal_id)
