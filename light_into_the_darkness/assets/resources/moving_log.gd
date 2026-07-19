class_name MovingLog
extends StandableSurface

@export var wait_time := 1.0

@onready var timer := $Timer

var speed: float
var flow_direction: Vector2
var player_on_log := false
var sinking := false
var delta_move := Vector2.ZERO


func _ready():
	super._ready()
	
	var body := self
	if body:
		for i in range(1, 33):
			body.set_collision_layer_value(i, false)
		
		body.set_collision_layer_value(HEIGHT_TO_LAYER[height_level], true)


func _physics_process(delta: float) -> void:
	delta_move = flow_direction * speed * delta
	
	position += delta_move
	
	if GameManager.player.current_surface == self:
		GameManager.player.global_position += delta_move
		


func destroy_log():
	speed = 0.0
	timer.wait_time = wait_time
	timer.start()
	await timer.timeout
	if GameManager.player.current_surface == self:
		SceneManager.change_scene(Portal.Destination.TOWN)
	queue_free()


func entered() -> void:
	GameManager.player.set_collision_mask_value(1, false)
	$AnimationPlayer.play("sink")


func exited() -> void:
	GameManager.player.set_collision_mask_value(1, true)
	$AnimationPlayer.stop()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if GameManager.player.current_surface == self:
		SceneManager.change_scene(Portal.Destination.TOWN)
	queue_free()


func disable_static_body(disable: bool):
	$Outline/CollisionPolygon2D.disabled = !disable
