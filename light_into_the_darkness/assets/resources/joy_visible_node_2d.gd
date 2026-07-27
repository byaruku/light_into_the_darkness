class_name JoyVisibleNode2D
extends Node2D


func _ready() -> void:
	add_to_group("joy_visible")
	visible = false


func show_for_joy():
	visible = true


func hide_for_joy():
	visible = false
