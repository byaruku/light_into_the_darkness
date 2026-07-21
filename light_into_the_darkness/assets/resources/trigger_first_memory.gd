extends TriggerArea

@export var memory: Portal.Destination


func _on_body_entered(body: Node2D) -> void:
	if GameManager.memory_completed[memory]:
		queue_free()
	else:
		super._on_body_entered(body)
