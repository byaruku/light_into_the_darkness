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


@export_category("Stats")
@export var speed := 100.0
@export var crouch_speed := 25.0
@export var jump_height := 1
@export var jump_distance := 8
@export var jump_duration := 0.25

var movement_state = MovementState.IDLE
var action_state = ActionState.NORMAL

var move_direction := Vector2.ZERO
var facing_direction := Vector2.DOWN
var jump_direction := Vector2.ZERO

var current_surface: StandableSurface = null

var can_break_objects := false
var in_cutscene := false

var direction_offsets = {
	Vector2.UP: Vector2(0, -16),
	Vector2.DOWN: Vector2(0, 4),
	Vector2.LEFT: Vector2(-12, 0),
	Vector2.RIGHT: Vector2(12, 0)
}

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
	if in_cutscene:
		return
	
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
	
	break_object()
	
	# movement_state
	if move_direction == Vector2.ZERO:
		movement_state = MovementState.IDLE
	else:
		movement_state = MovementState.RUN


func update_animation() -> void:
	animation_tree.set("parameters/idle/blend_position", facing_direction)
	animation_tree.set("parameters/walk/blend_position", facing_direction)
	animation_tree.set("parameters/run/blend_position", facing_direction)
	animation_tree.set("parameters/crouch_idle/blend_position", facing_direction)
	animation_tree.set("parameters/crouch/blend_position", facing_direction)
	animation_tree.set("parameters/jump/blend_position", facing_direction)
	
	# jump has highest priority
	if action_state == ActionState.JUMP:
		animation_playback.travel("jump")
		return
	
	# crouch
	if action_state == ActionState.CROUCH:
		if movement_state == MovementState.RUN:
			animation_playback.travel("crouch")
		else:
			animation_playback.travel("crouch_idle")
		return
	
	# normal movement
	match movement_state:
		MovementState.IDLE:
			animation_playback.travel("idle")
		MovementState.RUN:
			if mask_manager.active_mask != null && mask_manager.active_mask.mask_type == MaskManager.MaskType.JOY:
				animation_playback.travel("run")
			else:
				animation_playback.travel("walk")


func update_facing_direction():
	update_facing_direction_from_vector(move_direction)


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


func update_interaction_position():
	var offset = direction_offsets[facing_direction] + Vector2(0, 8) if facing_direction == Vector2.DOWN and get_current_height() > 0 else direction_offsets[facing_direction]
	interaction_area.position = offset
	jump_check_area.position = offset


func start_jump():
	if action_state != ActionState.NORMAL:
		return
	
	var target_platform = get_jump_platform()
	
	# Jump on and of plattform
	if target_platform:
		var height_diff = target_platform.height_level - get_current_height()
		
		if ((height_diff > 0 and height_diff <= jump_height) or target_platform is MovingLog) and target_platform.allow_jump_on:
			jump_to_platform(target_platform)
			return
		
		if height_diff < 0 and abs(height_diff) <= jump_height and target_platform.allow_jump_down:
			jump_down(target_platform)
			return
	
	normal_jump()


func jump_to_platform(platform: StandableSurface):
	set_action_state(ActionState.JUMP)
	$CollisionShape2D.disabled = true
	
	if platform is MovingLog:
		if platform.timer.is_stopped():
			var tween = create_tween()
			tween.tween_property(self, "global_position", platform.get_landing_position() + platform.flow_direction * platform.speed * jump_duration, jump_duration)
			await tween.finished
			
			if current_surface is MovingLog:
				current_surface.exited()
			platform.entered()
		else:
			$CollisionShape2D.disabled = false
			set_action_state(ActionState.NORMAL)
			return
	else:
		var tween = create_tween()
		tween.tween_property(self, "global_position", platform.get_landing_position(), jump_duration)
		await tween.finished
	
	if current_surface:
		if current_surface is not MovingLog:
			get_tree().call_group("Height" + str(current_surface.height_level), "disable_static_body", false)
	else:
		get_tree().call_group("Height" + str(0), "disable_static_body", false)
	
	current_surface = platform
	
	if current_surface is not MovingLog:
		get_tree().call_group("Height" + str(current_surface.height_level), "disable_static_body", true)
	
	velocity = Vector2.ZERO
	
	update_height_layer()
	
	$CollisionShape2D.disabled = false
	set_action_state(ActionState.NORMAL)


func jump_down(platform: StandableSurface):
	if get_current_height() <= 0:
		return
	
	set_action_state(ActionState.JUMP)
	$CollisionShape2D.disabled = true
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", platform.get_landing_position(), jump_duration)
	await tween.finished
	
	velocity = Vector2.ZERO
	
	if current_surface is MovingLog:
		current_surface.exited()
	else:
		get_tree().call_group("Height" + str(current_surface.height_level), "disable_static_body", false)
	
	if platform.height_level > 0:
		current_surface = platform
		get_tree().call_group("Height" + str(current_surface.height_level), "disable_static_body", true)
	else:
		current_surface = null
		get_tree().call_group("Height" + str(0), "disable_static_body", true)
	
	update_height_layer()
	
	$CollisionShape2D.disabled = false
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
	
	for interactable in areas:
		if interactable is Interactable:
			movement_state = MovementState.IDLE
			update_animation()
			await interactable.interact()


func break_object():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		
		if collision.get_collider() is BreakableObject:
			var object: BreakableObject = collision.get_collider()
			
			if can_break_objects:
				object.break_object()


func _on_scare_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.flee_from(global_position)


func update_height_layer():
	set_height_collision(get_current_height())
	z_index = get_current_height() * 10


func can_stand_up() -> bool:
	return stand_check_area.get_overlapping_bodies().is_empty()


func can_jump_to(target_position: Vector2) -> bool:
	var motion = target_position - global_position
	return not test_move(global_transform, motion)


func get_jump_platform():
	for body in jump_check_area.get_overlapping_bodies():
		if body is PlatformLanding:
			var platform = body.get_platform()
			if platform.height_level != get_current_height() or (platform is MovingLog and platform != current_surface):
				return platform
	return null


func get_current_height() -> int:
	if current_surface:
		return current_surface.height_level
	return 0


func set_height_collision(layer: int):
	if layer == 0:
		set_collision_mask_value(StandableSurface.HEIGHT_TO_LAYER[0], false)
		set_collision_mask_value(StandableSurface.HEIGHT_TO_LAYER[1], false)
		set_collision_mask_value(StandableSurface.HEIGHT_TO_LAYER[2], false)
		set_collision_mask_value(StandableSurface.HEIGHT_TO_LAYER[3], false)
	else:
		set_collision_mask_value(StandableSurface.HEIGHT_TO_LAYER[0], true)
		set_collision_mask_value(StandableSurface.HEIGHT_TO_LAYER[1], true)
		set_collision_mask_value(StandableSurface.HEIGHT_TO_LAYER[2], true)
		set_collision_mask_value(StandableSurface.HEIGHT_TO_LAYER[3], true)
	
		set_collision_mask_value(StandableSurface.HEIGHT_TO_LAYER[layer], false)
	
	if action_state != ActionState.CROUCH:
		set_collision_mask_value(LAYER_CROUCH, true)


func pause_player():
	animation_tree.active = false


func resume_player():
	animation_tree.active = true
	update_animation()


func enable_joy_vision():
	get_tree().call_group("joy_visible", "show_for_joy")


func disable_joy_vision():
	get_tree().call_group("joy_visible", "hide_for_joy")


func start_cutscene():
	in_cutscene = true
	
	velocity = Vector2.ZERO
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)


func end_cutscene():
	in_cutscene = false
	
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)


func cutscene_walk_to(target_position: Vector2):
	while global_position.distance_to(target_position) > 2:
		var dir = (target_position - global_position).normalized()
		
		update_facing_direction_from_vector(dir)
		
		velocity = dir * speed
		
		move_and_slide()
		
		await  get_tree().physics_frame
		
	velocity = Vector2.ZERO
