class_name JoyVisibleShader
extends Node2D


func _ready() -> void:
	visible = false
	add_to_group("joy_visible")
	$CanvasLayer.visible = false


func show_for_joy():
	visible = true
	$CanvasLayer.visible = true


func hide_for_joy():
	visible = false
	$CanvasLayer.visible = false
