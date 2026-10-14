extends Control

signal new_game_pressed()
signal settings_pressed()
signal exit_pressed()

@export var credits_scene: PackedScene

@export var de_button: TextureButton
@export var en_button: TextureButton
@export var new_button: Button
@export var setting_button: Button
@export var credits_button: Button
@export var exit_button: Button

@onready var buttons: Array = [de_button, en_button, new_button, setting_button, credits_button, exit_button]
@onready var last_pressed_button: Button = new_button

var credits
var dialogue_runner: YarnDialogueRunner = DialogueManager.dialogue_runner


func _ready() -> void:
	for button in buttons:
		button.focus_mode = FOCUS_ALL
		button.focus_entered.connect(AudioManager.play_ui_hover)
		button.mouse_entered.connect(AudioManager.play_ui_hover)
		button.pressed.connect(AudioManager.play_ui_select)
	
	credits = credits_scene.instantiate()
	get_tree().root.add_child.call_deferred(credits)
	
	credits.closed.connect(show_menu)
	PauseManager.settings_menu.closed.connect(show_menu)
	SettingsManager.change_language.connect(_on_language_change)
	
	_show_languages()


func show_menu():
	last_pressed_button.grab_focus()


func _show_languages() -> void:
	var current := dialogue_runner.get_locale()
	if current == "de":
		de_button.disabled = true
		en_button.disabled = false
		de_button.focus_mode = FOCUS_NONE
		en_button.focus_mode = FOCUS_ALL
	else:
		de_button.disabled = false
		en_button.disabled = true
		de_button.focus_mode = FOCUS_ALL
		en_button.focus_mode = FOCUS_NONE
	
	new_button.grab_focus()
	
	SettingsManager.change_language.emit()


func _on_language_change() -> void:
	var current := dialogue_runner.get_locale()
	if current == "de":
		new_button.text = "Neues Spiel"
		setting_button.text = "Optionen"
		credits_button.text = "Credits"
		exit_button.text = "Verlassen"
	else:
		new_button.text = "New Game"
		setting_button.text = "Settings"
		credits_button.text = "Credits"
		exit_button.text = "Exit"


func _on_new_game_pressed() -> void:
	$MarginContainer.hide()
	last_pressed_button = new_button
	new_game_pressed.emit()


func _on_settings_pressed() -> void:
	settings_pressed.emit()
	last_pressed_button = setting_button


func _on_credits_pressed() -> void:
	credits.show_credits()
	last_pressed_button = credits_button


func _on_exit_pressed() -> void:
	exit_pressed.emit()
	last_pressed_button = exit_button


func _on_de_button_pressed() -> void:
	dialogue_runner.set_locale("de")
	_show_languages()


func _on_en_button_pressed() -> void:
	dialogue_runner.set_locale("en")
	_show_languages()
