class_name JoyMask
extends MaskAbility

@export var speed_multiplier := 1.5
@export var jump_multiplier := 2


func activate(player: Player):
	player.speed *= speed_multiplier
	player.jump_height *= jump_multiplier
	
	player.enable_joy_vision()


func deactivate(player: Player):
	player.speed /= speed_multiplier
	player.jump_height /= jump_multiplier
	
	player.disable_joy_vision()
