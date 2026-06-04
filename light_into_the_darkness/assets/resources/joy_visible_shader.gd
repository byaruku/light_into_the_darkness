class_name JoyVisibleShader
extends CanvasLayer


func _ready() -> void:
	add_to_group("joy_visible")
	visible = false


func show_for_joy():
	visible = true


func hide_for_joy():
	visible = false
