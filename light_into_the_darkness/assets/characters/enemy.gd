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

var chase_direction := Vector2.ZERO
var chase_timer := 0.0

var flee_source: Vector2
var flee_timer := 0.0
var flee_direction := Vector2.ZERO
var flee_retarget_timer := 0.0


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
			chase_player(delta)
		
		State.FLEE:
			flee_timer -= delta
			flee_retarget_timer -= delta
			
			if flee_retarget_timer <= 0:
				update_flee_direction()
				flee_retarget_timer = randf_range(0.3, 0.8)
			
			velocity = flee_direction * speed * 2
			move_and_slide()
			
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


func chase_player(delta):
	chase_timer -= delta
	
	if chase_timer <= 0:
		var dir = (player.global_position - global_position).normalized()
		var angle_offset = deg_to_rad(randf_range(-45.0, 45.0))
		chase_direction = dir.rotated(angle_offset)
		chase_timer = randf_range(0.5, 1.5)
	
	velocity = chase_direction * speed
	move_and_slide()


func flee_from(source: Vector2):
	state = State.FLEE
	flee_timer = 3.0
	flee_source = source
	
	update_flee_direction()
	flee_retarget_timer = 0.0


func update_flee_direction():
	var dir = (global_position - flee_source).normalized()
	var angle_offset = deg_to_rad(randf_range(-45.0, 45.0))
	flee_direction = dir.rotated(angle_offset)
