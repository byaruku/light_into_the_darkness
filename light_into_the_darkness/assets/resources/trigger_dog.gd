extends TriggerArea

@export var packed_dog: PackedScene

@onready var marker := $Marker2D

func _on_body_entered(body: Node2D) -> void:
	await super._on_body_entered(body)
	
	if body is Player:
		var dog = packed_dog.instantiate()
		dog.global_position = marker.global_position
		get_parent().add_child(dog)

		self.queue_free()
