class_name RageMask
extends MaskAbility

@export var scare_radius := 80.0

func activate(player: Player):
	player.can_break_objects = true
	player.scare_area.monitoring = true
	var circle := player.scare_collision.shape as CircleShape2D
	circle.radius = scare_radius


func deactivate(player: Player):
	player.can_break_objects = false
	player.scare_area.monitoring = false
