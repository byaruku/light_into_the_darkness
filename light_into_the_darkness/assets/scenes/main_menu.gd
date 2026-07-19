extends Control

signal new_game_pressed()
signal settings_pressed()
signal about_pressed()
signal exit_pressed()

var buttons := []

func _ready() -> void:
	buttons.append($MarginContainer/VBoxContainer/NewGameButton)
	buttons.append($MarginContainer/VBoxContainer/SettingButton)
	buttons.append($MarginContainer/VBoxContainer/AboutButton)
	buttons.append($MarginContainer/VBoxContainer/ExitButton)

func show_menu():
	for button in buttons:
		button.focus_mode = FOCUS_ALL
	$MarginContainer/VBoxContainer/NewGameButton.grab_focus()


func _on_new_game_pressed() -> void:
	for button in buttons:
		button.focus_mode = FOCUS_NONE
	new_game_pressed.emit()


func _on_settings_pressed() -> void:
	settings_pressed.emit()


func _on_about_pressed() -> void:
	about_pressed.emit()


func _on_exit_pressed() -> void:
	exit_pressed.emit()
