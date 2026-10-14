extends CanvasLayer

signal closed

@export var master_slider: HSlider
@export var music_slider: HSlider
@export var sfx_slider: HSlider
@export var master_label: Label
@export var music_label: Label
@export var sfx_label: Label

@export var fullscreen_button: CheckButton
@export var vsync_button: CheckButton

@export var save_and_back_button: Button

@onready var buttons: Array = [
	fullscreen_button,
	vsync_button,
	save_and_back_button
]


func _ready() -> void:
	SettingsManager.change_language.connect(_on_language_change)
	_on_language_change()
	
	hide()
	for button in buttons:
		button.focus_entered.connect(AudioManager.play_ui_hover)
		button.mouse_entered.connect(AudioManager.play_ui_hover)
		button.pressed.connect(AudioManager.play_ui_select)


func show_menu():
	master_slider.value = SettingsManager.master_volume
	music_slider.value = SettingsManager.music_volume
	sfx_slider.value = SettingsManager.sfx_volume
	
	fullscreen_button.button_pressed = SettingsManager.fullscreen
	vsync_button.button_pressed = SettingsManager.vsync
	
	show()
	
	master_slider.grab_focus()


func close_menu():
	hide()
	closed.emit()


func _on_language_change() -> void:
	var current: String = DialogueManager.dialogue_runner.get_locale()
	if current == "de":
		master_label.text = "Gesamt"
		music_label.text = "Musik"
		sfx_label.text = "SFX"
		fullscreen_button.text = "Vollbild"
		vsync_button.text = "VSync"
		save_and_back_button.text = "Speichern und zurück"
	else:
		master_label.text = "Master"
		music_label.text = "Music"
		sfx_label.text = "SFX"
		fullscreen_button.text = "Fullscreen"
		vsync_button.text = "VSync"
		save_and_back_button.text = "Save and back"


func _on_master_slider_value_changed(value: float) -> void:
	SettingsManager.set_master_volume(value)
	AudioManager.play_ui_select()


func _on_music_slider_value_changed(value: float) -> void:
	SettingsManager.set_music_volume(value)
	AudioManager.play_ui_select()


func _on_sfx_slider_value_changed(value: float) -> void:
	SettingsManager.set_sfx_volume(value)
	AudioManager.play_ui_select()


func _on_fullscreen_button_toggled(enabled: bool) -> void:
	SettingsManager.fullscreen = enabled
	SettingsManager.apply_settings()


func _on_vsync_button_toggled(enabled: bool) -> void:
	SettingsManager.vsync = enabled
	SettingsManager.apply_settings()


func _on_save_and_back_button_pressed() -> void:
	SettingsManager.save_settings()
	close_menu()
