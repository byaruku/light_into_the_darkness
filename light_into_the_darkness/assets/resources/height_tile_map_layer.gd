extends TileMapLayer

@export_range(0,3) var height_level := 1


func _ready():
	self.add_to_group("Height" + str(height_level))


func disable_static_body(disable: bool):
	collision_enabled = disable
