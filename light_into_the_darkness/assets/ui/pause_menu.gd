extends CanvasLayer

signal resume_pressed
signal settings_pressed
signal leave_memory_pressed
signal main_menu_pressed

@export var resume_button: Button
@export var setting_button: Button
@export var leave_memory_button: Button
@export var main_menu_button: Button

@onready var buttons := [
	resume_button,
	setting_button,
	leave_memory_button,
	main_menu_button
]


func _ready() -> void:
	SettingsManager.change_language.connect(_on_language_change)
	_on_language_change()
	
	hide()
	for button in buttons:
		button.focus_entered.connect(AudioManager.play_ui_hover)
		button.mouse_entered.connect(AudioManager.play_ui_hover)
		button.pressed.connect(AudioManager.play_ui_select)


func _on_language_change() -> void:
	var current: String = DialogueManager.dialogue_runner.get_locale()
	if current == "de":
		resume_button.text = "Fortfahren"
		setting_button.text = "Optionen"
		leave_memory_button.text = "Welt verlassen"
		main_menu_button.text = "Hauptmenu"
	else:
		resume_button.text = "Resume"
		setting_button.text = "Settings"
		leave_memory_button.text = "Leave world"
		main_menu_button.text = "Main menu"


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
