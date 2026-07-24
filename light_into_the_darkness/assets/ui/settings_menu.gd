extends CanvasLayer

signal closed

@export var master_slider: HSlider
@export var music_slider: HSlider
@export var sfx_slider: HSlider

@export var fullscreen_button: CheckButton
@export var vsync_button: CheckButton

@onready var buttons: Array = [
	fullscreen_button,
	vsync_button,
	$Control/VBoxContainer/SaveAndBackButton
]


func _ready() -> void:
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
