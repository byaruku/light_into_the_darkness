class_name JumpPlatform
extends Node2D

@export_range(0,3) var height_level := 1
@export var allow_jump_on := true
@export var allow_jump_down := true

const HEIGHT_TO_LAYER = {
	0: 5,
	1: 6,
	2: 7,
	3: 8
}


func _ready():
	var body := $StaticBody2D
	
	if body:
		for i in range(1, 33):
			body.set_collision_layer_value(i, false)
		
		if height_level == 0:
			body.set_collision_layer_value(HEIGHT_TO_LAYER[height_level], true)
		else:
			body.set_collision_layer_value(1, true)
	
	var landing := $LandingBody
	for i in range(1, 33):
		landing.set_collision_layer_value(i, false)
	landing.set_collision_layer_value(HEIGHT_TO_LAYER[height_level], true)
	


func get_landing_position() -> Vector2:
	return $Marker2D.global_position
