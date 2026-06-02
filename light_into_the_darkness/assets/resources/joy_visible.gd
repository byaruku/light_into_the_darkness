class_name JoyVisible
extends Node2D


func _ready() -> void:
	visible = false
	add_to_group("joy_visible")


func show_for_joy():
	visible = true


func hide_for_joy():
	visible = false
