class_name Enemy
extends CharacterBody2D

enum State {
	WANDER,
	CHASE,
	FLEE
}

@export var speed := 70.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var player: Player

var state := State.CHASE

var chase_direction := Vector2.ZERO
var chase_timer := 0.0

var flee_source: Vector2
var flee_timer := 0.0
var flee_direction := Vector2.ZERO
var flee_retarget_timer := 0.0


func _ready():
	player = GameManager.player


func _physics_process(delta: float) -> void:
	if GameManager.state_machine.current_state is PauseState:
		return
	
	match state:
		State.WANDER:
			pass
		State.CHASE:
			chase_player()
		
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


func _on_touch_area_body_entered(body: Node2D) -> void:
	if body is Player:
		GameManager.leave_memory()


func chase_player():
	navigation_agent.target_position = player.global_position
	
	var next_position = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_position)
	
	velocity = direction * speed
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
