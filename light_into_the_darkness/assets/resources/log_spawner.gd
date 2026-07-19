class_name LogSpawner
extends Node2D

@export var log_scene: PackedScene

@export var min_spawn_time := 2.0
@export var max_spawn_time := 6.0

@export var min_speed := 30.0
@export var max_speed := 50.0

@export var flow_direction := Vector2.DOWN

@onready var timer := $Timer


func _ready():
	spawn()
	restart_timer()


func _on_timer_timeout():
	spawn()
	restart_timer()


func restart_timer():
	timer.wait_time = randf_range(min_spawn_time, max_spawn_time)
	timer.start()


func spawn():
	var trunk = log_scene.instantiate()

	trunk.speed = randf_range(min_speed, max_speed)
	trunk.flow_direction = flow_direction

	add_child(trunk)
