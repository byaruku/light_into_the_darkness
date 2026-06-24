extends CanvasLayer

signal closed

@onready var master_slider = $Control/VBoxContainer/MasterSlider
@onready var music_slider = $Control/VBoxContainer/MusicSlider
@onready var sfx_slider = $Control/VBoxContainer/SfxSlider

@onready var fullscreen_button = $Control/VBoxContainer/FullscreenButton
@onready var vsync_button = $Control/VBoxContainer/VsyncButton


func _ready() -> void:
	hide()


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


func _on_music_slider_value_changed(value: float) -> void:
	SettingsManager.set_music_volume(value)


func _on_sfx_slider_value_changed(value: float) -> void:
	SettingsManager.set_sfx_volume(value)


func _on_fullscreen_button_toggled(enabled: bool) -> void:
	SettingsManager.fullscreen = enabled
	SettingsManager.apply_settings()


func _on_vsync_button_toggled(enabled: bool) -> void:
	SettingsManager.vsync = enabled
	SettingsManager.apply_settings()


func _on_save_and_back_button_pressed() -> void:
	SettingsManager.save_settings()
	close_menu()
