extends Control

signal new_game_pressed()
signal settings_pressed()
signal exit_pressed()

@export var credits_scene: PackedScene

var credits
var buttons := []


func _ready() -> void:
	buttons.append($MarginContainer/VBoxContainer/NewGameButton)
	buttons.append($MarginContainer/VBoxContainer/SettingButton)
	buttons.append($MarginContainer/VBoxContainer/CreditsButton)
	buttons.append($MarginContainer/VBoxContainer/ExitButton)
	
	for button in buttons:
		button.focus_entered.connect(AudioManager.play_ui_hover)
		button.mouse_entered.connect(AudioManager.play_ui_hover)
		button.pressed.connect(AudioManager.play_ui_select)
	
	credits = credits_scene.instantiate()
	get_tree().root.add_child.call_deferred(credits)
	
	credits.closed.connect(grab_focus_credit)


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


func _on_credits_pressed() -> void:
	credits.show_credits()


func _on_exit_pressed() -> void:
	exit_pressed.emit()


func grab_focus_credit() -> void:
	$MarginContainer/VBoxContainer/CreditsButton.grab_focus()
