extends Node2D

@export var min_pause := 30.0
@export var max_pause := 300.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var animations: Array[StringName] = [
	&"wave1",
	&"wave2",
	&"wave3"
]


func _ready() -> void:
	play_random_animation()


func play_random_animation() -> void:
	await get_tree().create_timer(randf_range(0.0, max_pause)).timeout
	
	while is_inside_tree():
		var animation: StringName = animations.pick_random()
		
		animation_player.play(animation)
		
		await animation_player.animation_finished
		
		if not is_inside_tree():
			return
		
		await get_tree().create_timer(randf_range(min_pause, max_pause)).timeout
