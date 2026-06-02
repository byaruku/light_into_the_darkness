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

const LAYER_CROUCH = 4
const LAYER_JUMP_GROUND = 5
const LAYER_JUMP_HEIGHT1 = 6
const LAYER_JUMP_HEIGHT2 = 7
const LAYER_JUMP_HEIGHT3 = 8

@export_category("Stats")
@export var speed := 100.0
@export var crouch_speed := 25.0
@export var jump_height := 1
@export var jump_distance := 16
@export var jump_duration := 0.2

var movement_state = MovementState.IDLE
var action_state = ActionState.NORMAL

var move_direction := Vector2.ZERO
var facing_direction := Vector2.DOWN
var jump_direction := Vector2.ZERO

var current_height := 0
var current_platform: JumpPlatform = null

var can_break_walls := false

@onready var mask_manager: MaskManager = $MaskManager
@onready var scare_area: Area2D = $ScareArea
@onready var scare_collision: CollisionShape2D = $ScareArea/CollisionShape2D

@onready var interaction_area: Area2D = $InteractionArea
@onready var stand_check_area: Area2D = $StandCheckArea
@onready var jump_check_area: Area2D = $JumpCheckArea

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]


func _ready() -> void:
	GameManager.player = self
	mask_manager.player = self
	animation_tree.active = true
	update_height_layer()


func handle_update(delta: float) -> void:
	handle_action_input()
	
	movement_loop(delta)
	
	update_animation()
	
	if Input.is_action_just_pressed("interact"):
		try_interact()


func handle_action_input() -> void:
	# jump
	if Input.is_action_just_pressed("jump"):
		if action_state == ActionState.NORMAL:
			start_jump()
	
	# crouch
	if action_state != ActionState.JUMP:
		if Input.is_action_pressed("crouch"):
			set_action_state(ActionState.CROUCH)
		else:
			if can_stand_up():
				set_action_state(ActionState.NORMAL)
			else:
				set_action_state(ActionState.CROUCH)
	
	if Input.is_action_just_pressed("mask_1"):
		var mask = mask_manager.get_mask(MaskManager.MaskType.RAGE)
		if mask and mask_manager.can_use(mask):
			mask_manager.use_mask(mask)
		else:
			print("Can't use RageMask")

	if Input.is_action_just_pressed("mask_2"):
		var mask = mask_manager.get_mask(MaskManager.MaskType.JOY)
		if mask and mask_manager.can_use(mask):
			mask_manager.use_mask(mask)
		else:
			print("Can't use JoyMask")

func set_action_state(new_state):
	if action_state == new_state:
		return
	
	action_state = new_state
	
	match action_state:
		ActionState.NORMAL:
			set_collision_mask_value(LAYER_CROUCH, true)
		ActionState.CROUCH:
			set_collision_mask_value(LAYER_CROUCH, false)


func movement_loop(_delta: float) -> void:
	# at jump no normal input
	if action_state == ActionState.JUMP:
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
	interaction_area.position = facing_direction * 16
	jump_check_area.position = facing_direction * 8


func start_jump():
	if action_state != ActionState.NORMAL:
		return
	
	var target_platform = get_jump_platform()
	
	# Jump on and of plattform
	if target_platform:
		if target_platform.height_level < current_height:
			jump_down(target_platform)
			return
		elif target_platform.height_level <= current_height + jump_height and not target_platform.height_level == current_height:
			jump_to_platform(target_platform)
			return
	
	normal_jump()


func jump_to_platform(platform: JumpPlatform):
	set_action_state(ActionState.JUMP)
	
	jump_direction = facing_direction.normalized()
	
	var target_position = global_position + jump_direction * jump_distance
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, jump_duration)
	await tween.finished
	
	current_platform = platform
	
	velocity = Vector2.ZERO
	
	current_height = platform.height_level
	update_height_layer()
	
	set_action_state(ActionState.NORMAL)


func jump_down(platform: JumpPlatform):
	if current_height <= 0:
		return
	
	set_action_state(ActionState.JUMP)
	
	jump_direction = facing_direction.normalized()
	
	var target_position = global_position + jump_direction * jump_distance
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, jump_duration)
	await tween.finished
	
	velocity = Vector2.ZERO
	
	current_height = max(current_height - 1, 0)
	
	if current_height == 0:
		current_platform = null
	else:
		current_platform = platform
	
	update_height_layer()
	
	set_action_state(ActionState.NORMAL)


func normal_jump():
	set_action_state(ActionState.JUMP)
	jump_direction = facing_direction.normalized()
	
	var target_position = global_position + jump_direction * jump_distance
	if not can_jump_to(target_position):
		set_action_state(ActionState.NORMAL)
		return
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, jump_duration)
	await tween.finished
	
	if not is_inside_tree():
		return
	
	set_action_state(ActionState.NORMAL)


func try_interact():
	var areas = interaction_area.get_overlapping_areas()
	
	if areas.is_empty():
		return
	
	var interactable = areas[0]
	
	if interactable is Interactable:
		movement_state = MovementState.IDLE
		update_animation()
		await interactable.interact()


func update_height_layer():
	match current_height:
		0:
			set_height_collision(LAYER_JUMP_GROUND)
		1:
			set_height_collision(LAYER_JUMP_HEIGHT1)
		2:
			set_height_collision(LAYER_JUMP_HEIGHT2)
		3:
			set_height_collision(LAYER_JUMP_HEIGHT3)
	
	z_index = current_height * 100


func can_stand_up() -> bool:
	return stand_check_area.get_overlapping_bodies().is_empty()


func can_jump_to(target_position: Vector2) -> bool:
	var motion = target_position - global_position
	return not test_move(global_transform, motion)


func get_jump_platform():
	var bodies = jump_check_area.get_overlapping_bodies()
	for body in bodies:
		if body is JumpPlatform:
			return body
	
	return null


func set_height_collision(layer: int):
	set_collision_mask_value(LAYER_JUMP_GROUND, true)
	set_collision_mask_value(LAYER_JUMP_HEIGHT1, true)
	set_collision_mask_value(LAYER_JUMP_HEIGHT2, true)
	set_collision_mask_value(LAYER_JUMP_HEIGHT3, true)

	set_collision_mask_value(layer, false)

	if action_state != ActionState.CROUCH:
		set_collision_mask_value(LAYER_CROUCH, true)
