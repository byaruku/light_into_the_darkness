class_name Player
extends CharacterBody2D

enum MovementState {
	IDLE,
	RUN,
}
enum ActionState {
	NORMAL,
	JUMP,
	CROUCH
}

@export_category("Stats")
@export var speed := 100
@export var crouch_speed := 25
@export var jump_speed := 75
@export var jump_duration := 0.2

var movement_state = MovementState.IDLE
var action_state = ActionState.NORMAL

var move_direction := Vector2.ZERO
var facing_direction := Vector2.DOWN
var jump_direction := Vector2.ZERO

@onready var interaction_area: Area2D = $InteractionArea
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]


func _ready() -> void:
	GameManager.player = self
	animation_tree.active =true


func handle_update(delta: float) -> void:
	handle_action_input()
	
	movement_loop(delta)
	
	update_animation()
	
	if Input.is_action_just_pressed("interact"):
		try_interact()


func handle_action_input() -> void:
	# jump
	if action_state != ActionState.CROUCH:
		if Input.is_action_just_pressed("jump"):
			if action_state != ActionState.JUMP:
				start_jump()
	
	# crouch
	if action_state != ActionState.JUMP:
		if Input.is_action_pressed("crouch"):
			action_state = ActionState.CROUCH
		else:
			action_state = ActionState.NORMAL


func movement_loop(_delta: float) -> void:
	# at jump no normal input
	if action_state == ActionState.JUMP:
		velocity = jump_direction * jump_speed
		move_and_slide()
		return
	
	# movement input
	move_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	move_direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	move_direction = move_direction.normalized()
	
	# update facing direction
	if move_direction != Vector2.ZERO:
		update_facing_direction()
		update_interaction_position()
	
	# speed depends on action_state
	var current_speed = speed
	
	match action_state:
		ActionState.CROUCH:
			current_speed = crouch_speed
	
	velocity = move_direction * current_speed
	move_and_slide()
	
	# sprite flip
	if move_direction.x < 0:
		$Sprite2D.flip_h = true
	elif move_direction.x > 0:
		$Sprite2D.flip_h = false
	
	# movement_state
	if move_direction == Vector2.ZERO:
		movement_state = MovementState.IDLE
	else:
		movement_state = MovementState.RUN

func update_animation() -> void:
	# jump has highest priority
	if action_state == ActionState.JUMP:
		animation_playback.travel("jump")
		return
	
	# crouch
	if action_state == ActionState.CROUCH:
		if movement_state == MovementState.RUN:
			animation_playback.travel("crouch_walk")
		else:
			animation_playback.travel("crouch_idle")
		return
	
	# normal movement
	match movement_state:
		MovementState.IDLE:
			animation_playback.travel("idle")
		MovementState.RUN:
			animation_playback.travel("run")


func update_facing_direction():
	if abs(move_direction.x) > abs(move_direction.y):
		if move_direction.x > 0:
			facing_direction = Vector2.RIGHT
		elif move_direction.x < 0:
			facing_direction = Vector2.LEFT
	else:
		if move_direction.y > 0:
			facing_direction = Vector2.DOWN
		elif move_direction.y < 0:
			facing_direction = Vector2.UP


func update_interaction_position():
	match facing_direction:
		Vector2.UP:
			interaction_area.position = Vector2(0,-10)
		Vector2.DOWN:
			interaction_area.position = Vector2(0,10)
		Vector2.LEFT:
			interaction_area.position = Vector2(-10,0)
		Vector2.RIGHT:
			interaction_area.position = Vector2(10,0)


func start_jump():
	action_state = ActionState.JUMP
	
	# save jump direction
	if move_direction != Vector2.ZERO:
		jump_direction = move_direction.normalized()
	else:
		jump_direction = facing_direction.normalized()
	
	var tween = create_tween()
	tween.tween_interval(jump_duration)
	await tween.finished
	
	velocity = Vector2.ZERO
	
	action_state = ActionState.NORMAL


func try_interact():
	var areas = interaction_area.get_overlapping_areas()
	
	if areas.is_empty():
		return
	
	var interactable = areas[0]
	
	if interactable is Interactable:
		movement_state = MovementState.IDLE
		update_animation()
		await interactable.interact()
