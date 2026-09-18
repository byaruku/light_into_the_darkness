extends Node

signal identity_changed(current, maximum)

@export var max_identity := 124

@onready var identity_bar := $CanvasLayer/TextureRect

var current_identity := 0


func clear_data():
	add_progress(-max_identity)
	current_identity = 0

func add_progress(amount: int):
	current_identity = clamp(
		current_identity + amount,
		0,
		max_identity
	)
	
	identity_changed.emit(current_identity)
