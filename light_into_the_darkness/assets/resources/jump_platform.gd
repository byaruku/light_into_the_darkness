class_name JumpPlatform
extends StandableSurface

func _ready():
	super._ready()
	
	var body := $StaticBody2D
	
	if body:
		for i in range(1, 33):
			body.set_collision_layer_value(i, false)
		
		if height_level == 0:
			body.set_collision_layer_value(HEIGHT_TO_LAYER[height_level], true)
		else:
			body.set_collision_layer_value(1, true)
	
	disable_static_body(false)


func disable_static_body(disable: bool):
	$StaticBody2D/CollisionShape2D.disabled = disable
	$Outline/CollisionPolygon2D.disabled = !disable
