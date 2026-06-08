extends CanvasLayer

signal resume_pressed
signal settings_pressed
signal leave_memory_pressed
signal main_menu_pressed

@onready var buttons := [
	$Panel/MarginContainer/VBoxContainer/ResumeButton,
	$Panel/MarginContainer/VBoxContainer/SettingButton,
	$Panel/MarginContainer/VBoxContainer/LeaveMemoryButton,
	$Panel/MarginContainer/VBoxContainer/MainMenuButton
]


func _ready() -> void:
	hide()


func show_menu():
	buttons[2].visible = GameManager.is_in_memory
	$Panel/MarginContainer/VBoxContainer/Spacer.visible = !GameManager.is_in_memory
	show()
	
	buttons[0].grab_focus()


func _on_resume_button_pressed() -> void:
	resume_pressed.emit()


func _on_setting_button_pressed() -> void:
	settings_pressed.emit()


func _on_leave_memory_button_pressed() -> void:
	leave_memory_pressed.emit()


func _on_main_menu_button_pressed() -> void:
	main_menu_pressed.emit()
