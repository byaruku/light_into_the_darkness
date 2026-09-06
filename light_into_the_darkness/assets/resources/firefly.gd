class_name Firefly
extends Interactable

signal collected(firefly)

@export var move_radius := 24.0
@export var speed := 20.0
@export var pause_time := Vector2(0.3, 1.2)
@export var base_energy := 1.0

@onready var light: PointLight2D = $PointLight2D

var origin: Vector2
var target: Vector2
var waiting := false


func _ready() -> void:
	$AnimationPlayer.seek(randf() * $AnimationPlayer.current_animation_length, true)
	
	start_glow()


func start() -> void:
	origin = global_position
	
	choose_target()


func _process(delta: float) -> void:
	if waiting:
		return
	
	global_position = global_position.move_toward(target, speed * delta)
	
	if global_position.distance_to(target) < 2:
		wait()


func choose_target():
	target = origin + Vector2(randf_range(-move_radius, move_radius), randf_range(-move_radius, move_radius))


func wait():
	waiting = true
	
	await get_tree().create_timer(randf_range(pause_time.x, pause_time.y)).timeout
	
	choose_target()
	waiting = false


func interact():
	collected.emit(self)
	queue_free()


func start_glow():
	while is_inside_tree():
		var noise = randf_range(-0.4, 0.6)
		var next_energy = clamp(base_energy + noise, 0.3, 2.0)
		
		var duration = randf_range(0.2, 0.8)
		
		var glow_tween = create_tween()
		glow_tween.tween_property(light, "energy", next_energy, duration)
		
		await glow_tween.finished
