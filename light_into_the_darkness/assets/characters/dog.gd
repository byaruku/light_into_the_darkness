class_name Dog
extends CharacterBody2D

enum State {
	WANDER,
	CHASE,
	FLEE
}

@export_category("Stats")
@export var speed := 70.0

@export_category("Audio")
@export var barks: Array[AudioStream]
@export var bark_interval := Vector2(3.0, 7.0)

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var bark_audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var bark_timer: Timer = $BarkTimer

var player: Player

var state := State.CHASE
var facing_direction := Vector2.DOWN

var chase_direction := Vector2.ZERO
var chase_timer := 0.0

var flee_source: Vector2
var flee_timer := 0.0
var flee_direction := Vector2.ZERO
var flee_retarget_timer := 0.0


func _ready():
	while GameManager.player == null:
		await get_tree().process_frame
	player = GameManager.player
	animation_tree.active = true
	enter_chase()


func _physics_process(delta: float) -> void:
	if GameManager.state_machine.current_state is FreeRoamState:
		match state:
			State.WANDER, State.CHASE:
				chase_player()
			
			State.FLEE:
				update_flee(delta)
		
		update_animation()


func _on_touch_area_body_entered(body: Node2D) -> void:
	if body is Player:
		GameManager.leave_memory()


func enter_chase():
	state = State.CHASE
	
	bark_timer.wait_time = randf_range(1.0, 3.0)
	bark_timer.start()


func chase_player():
	navigation_agent.target_position = player.global_position
	
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	
	var next_position = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_position)
	
	update_facing_direction_from_vector(direction)
	
	velocity = direction * speed
	move_and_slide()


func update_flee(delta):
	flee_timer -= delta
	flee_retarget_timer -= delta

	if flee_retarget_timer <= 0:
		update_flee_direction()
		flee_retarget_timer = randf_range(0.3, 0.8)

	update_facing_direction_from_vector(flee_direction)

	velocity = flee_direction * speed * 2
	move_and_slide()

	if flee_timer <= 0:
		enter_chase()


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


func update_animation() -> void:
	animation_tree.set("parameters/walk/blend_position", facing_direction)
	animation_tree.set("parameters/run/blend_position", facing_direction)
	
	if velocity.length() < 5:
		animation_playback.travel("idle")
		return
	
	match state:
		State.WANDER:
			animation_playback.travel("walk")
		State.CHASE, State.FLEE:
			animation_playback.travel("run")


func update_facing_direction_from_vector(dir: Vector2):
	if dir == Vector2.ZERO:
		return

	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			facing_direction = Vector2.RIGHT
		else:
			facing_direction = Vector2.LEFT
	else:
		if dir.y > 0:
			facing_direction = Vector2.DOWN
		else:
			facing_direction = Vector2.UP


func _on_bark_timer_timeout() -> void:
	if state == State.FLEE:
		return
	
	if randf() < 0.6:
		bark_audio.stream = barks.pick_random()
		bark_audio.pitch_scale = randf_range(0.95, 1.05)
		bark_audio.play()
	
	schedule_next_bark()


func schedule_next_bark():
	bark_timer.wait_time = randf_range(
		bark_interval.x,
		bark_interval.y
	)
	bark_timer.start()
