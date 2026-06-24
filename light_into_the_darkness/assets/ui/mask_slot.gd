class_name MaskSlot
extends Control

@export var mask_type: MaskManager.MaskType

@onready var highlight = $Highlight
@onready var icon = $Icon


func set_active(active: bool):
	highlight.visible = active


func set_charges(charges: int):
	var frame = clamp(9 - charges, 0, 9)
	if frame == 9:
		icon.visible = false
	else:
		icon.frame = frame
		icon.visible = true
