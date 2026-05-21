class_name ChoiceSlot
extends Control

signal selected

@onready var label = $Label


func set_text(text: String):
	label.text = text


func set_selected(value: bool):
	if value:
		label.modulate = Color.YELLOW
	else:
		label.modulate = Color.WHITE
