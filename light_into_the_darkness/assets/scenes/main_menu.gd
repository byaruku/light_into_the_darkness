extends Control

signal new_game_pressed()
signal settings_pressed()
signal about_pressed()
signal exit_pressed()


func show_menu():
	$MarginContainer/VBoxContainer/NewGameButton.grab_focus()


func _on_new_game_pressed() -> void:
	new_game_pressed.emit()


func _on_settings_pressed() -> void:
	settings_pressed.emit()


func _on_about_pressed() -> void:
	about_pressed.emit()


func _on_exit_pressed() -> void:
	exit_pressed.emit()
