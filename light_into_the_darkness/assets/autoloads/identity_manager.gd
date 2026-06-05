extends Node

signal identity_changed(current, maximum)
signal identity_completed

@export var max_identity := 100

@onready var identity_bar := $CanvasLayer/IdentityBar

var current_identity := 0


func _ready() -> void:
	identity_bar.visible = false

func add_progress(amount: int):
	current_identity = clamp(
		current_identity + amount,
		0,
		max_identity
	)
	
	identity_changed.emit(
		current_identity,
		max_identity
	)
	
	if current_identity >= max_identity:
		identity_completed.emit()
