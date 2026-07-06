class_name JoyVisible
extends Node2D


@export var frame := 0


func _ready() -> void:
	$Sprite2D.frame = frame
	visible = false
	add_to_group("joy_visible")


func show_for_joy():
	visible = true


func hide_for_joy():
	visible = false
