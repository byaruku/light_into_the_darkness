extends CanvasLayer

signal closed


func _ready() -> void:
	hide()


func show_credits():
	show()
	
	$Control/MarginContainer/VBoxContainer/BackButton.grab_focus()


func _on_back_button_pressed() -> void:
	closed.emit()
	hide()
