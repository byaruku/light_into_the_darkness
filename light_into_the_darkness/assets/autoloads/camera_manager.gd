extends Node2D

@onready var camera: Camera2D = $Camera2D

var target: Node2D = null
var follow := true

@export var follow_speed := 8.0


func _physics_process(_delta: float) -> void:
	if follow and target:
		camera.global_position = target.global_position


func follow_node(node: Node2D):
	camera.reset_smoothing()
	camera.position_smoothing_enabled = true
	
	target = node
	follow = true


func stop_follow():
	follow = false


func move_to(target_position: Vector2, duration: float):
	stop_follow()
	
	var tween = create_tween()
	tween.tween_property(camera, "global_position", target_position, duration)
	
	await tween.finished


func switch_to(target_position: Vector2):
	stop_follow()
	
	camera.position_smoothing_enabled = false
	camera.reset_smoothing()
	camera.global_position = target_position
	


func resume_follow():
	camera.reset_smoothing()
	camera.position_smoothing_enabled = true
	
	follow = true


func zoom_to(zoom: Vector2, duration: float):
	var tween = create_tween()
	tween.tween_property(camera, "zoom", zoom, duration)
	
	await tween.finished
