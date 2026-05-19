class_name Player
extends CharacterBody2D

enum State {
	IDLE,
	RUN
}

@export_category("Stats")
@export var speed:= 400

var state:= State.IDLE
var move_direction:= Vector2(0,0)
var facing_direction:= Vector2.DOWN

@onready var interaction_area: Area2D = $InteractionArea
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]


func _ready() -> void:
	GameManager.player = self
	animation_tree.set_active(true)


func handle_update(delta) -> void:
	movement_loop()
	
	if Input.is_action_just_pressed("interact"):
		try_interact()


func movement_loop() -> void:
	move_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	move_direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))

	move_direction = move_direction.normalized()

	velocity = move_direction * speed

	move_and_slide()

	if move_direction != Vector2.ZERO:
		update_facing_direction()
		update_interaction_position()

		if move_direction.x < 0:
			$Sprite2D.flip_h = true
		elif move_direction.x > 0:
			$Sprite2D.flip_h = false

	if velocity != Vector2.ZERO and state != State.RUN:
		state = State.RUN
		update_animation()
	elif velocity == Vector2.ZERO and state != State.IDLE:
		state = State.IDLE
		update_animation()

func update_animation() -> void:
	match state:
		State.IDLE:
			animation_playback.travel("idle")
		State.RUN:
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


func try_interact():
	var areas = interaction_area.get_overlapping_areas()
	
	if areas.is_empty():
		print("Empty")
		return
	
	var interactable = areas[0]
	
	if interactable is Interactable:
		print("Interact")
		await interactable.interact()
