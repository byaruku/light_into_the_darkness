extends Node

signal identity_changed(current, maximum)

@export var max_identity := 124

@onready var identity_bar := $CanvasLayer/TextureRect
@onready var number_label := $CanvasLayer/TextureRect/MarginContainer/Label

var current_identity := 0


func clear_data():
	add_progress(-max_identity)
	current_identity = 0
	show_progress(false)

func add_progress(amount: int):
	current_identity = clamp(
		current_identity + amount,
		0,
		max_identity
	)
	
	identity_changed.emit(current_identity)

func show_progress(show: bool) -> void:
	number_label.text = str(int(float(IdentityManager.current_identity) / float(IdentityManager.max_identity) * 100.0)) + "%"
	number_label.visible = show
