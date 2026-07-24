extends CanvasLayer

signal closed

@onready var button: Button = $Control/MarginContainer/VBoxContainer/BackButton


func _ready() -> void:
	hide()
	button.focus_entered.connect(AudioManager.play_ui_hover)
	button.mouse_entered.connect(AudioManager.play_ui_hover)
	button.pressed.connect(AudioManager.play_ui_select)


func show_credits():
	show()
	
	button.grab_focus()


func _on_back_button_pressed() -> void:
	closed.emit()
	hide()
