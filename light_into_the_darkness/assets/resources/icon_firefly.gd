class_name IconFireFly
extends Node2D

@export var speed := 40.0
@export var pause_time := Vector2(0.3, 1.2)

var container: Control
var target: Vector2
var waiting := false


func _ready() -> void:
	$AnimationPlayer.seek(randf() * $AnimationPlayer.current_animation_length, true)
	
	container = get_parent()
	choose_target()


func _process(delta: float) -> void:
	if waiting:
		return
	
	position = position.move_toward(target, speed * delta)
	
	if position.distance_to(target) < 2:
		wait()


func choose_target():
	target = Vector2(randf_range(container.position.x, container.size.x), randf_range(container.position.y, container.size.y))


func wait():
	waiting = true
	
	await get_tree().create_timer(randf_range(pause_time.x, pause_time.y)).timeout
	
	choose_target()
	waiting = false
