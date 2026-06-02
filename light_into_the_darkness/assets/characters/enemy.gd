class_name Enemy
extends CharacterBody2D

enum State {
	WANDER,
	CHASE,
	FLEE
}

@export var speed := 50.0
@export var detection_distance := 120
var player: Player

var state := State.WANDER
var wander_target := Vector2.ZERO
var flee_timer := 0.0
var flee_source: Vector2


func _ready():
	player = GameManager.player
	choose_new_target()


func _physics_process(delta: float) -> void:
	match state:
		State.WANDER:
			if global_position.distance_to(wander_target) < 10:
				choose_new_target()
			
			velocity = (wander_target - global_position).normalized() * speed * 0.5
			
			move_and_slide()
			
			if global_position.distance_to(player.global_position) < detection_distance:
				state = State.CHASE
		
		State.CHASE:
			chase_player()
		
		State.FLEE:
			var dir = (global_position - flee_source).normalized()
			velocity = dir * speed * 2
			
			move_and_slide()
			
			flee_timer -= delta
			
			if flee_timer <= 0:
				state = State.CHASE


func choose_new_target():
	wander_target = global_position + Vector2(
		randf_range(-100, 100),
		randf_range(-100, 100)
	)


func _on_touch_area_body_entered(body: Node2D) -> void:
	if body is Player:
		GameManager.fail_memory()


func chase_player():
	var random_offset := Vector2(
		randf_range(-24, 24),
		randf_range(-24, 24)
	)
	
	var target = player.global_position + random_offset
	velocity = (target - global_position).normalized() * speed
	
	move_and_slide()


func flee_from(source: Vector2):
	state = State.FLEE
	flee_timer = 3.0
	flee_source = source
