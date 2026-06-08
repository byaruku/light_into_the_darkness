extends Node

var master_volume := 1.0
var music_volume := 1.0
var sfx_volume := 1.0

var fullscreen := true
var vsync := true


func _ready() -> void:
	load_settings()


func set_master_volume(value: float):
	master_volume = value
	
	var bus = AudioServer.get_bus_index("Master")
	
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))


func set_music_volume(value: float):
	music_volume = value
	
	var bus = AudioServer.get_bus_index("Music")
	
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))


func set_sfx_volume(value: float):
	sfx_volume = value
	
	var bus = AudioServer.get_bus_index("SFX")
	
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))


func save_settings():
	var config = ConfigFile.new()
	
	config.set_value(
		"audio",
		"master",
		master_volume
	)
	
	config.set_value(
		"audio",
		"music",
		music_volume
	)
	
	config.set_value(
		"audio",
		"sfx",
		sfx_volume
	)
	
	config.set_value(
		"graphics",
		"fullscreen",
		fullscreen
	)
	
	config.set_value(
		"graphics",
		"vsync",
		vsync
	)
	
	config.save("user://settings.cfg")
	
	if GameManager.state_machine.current_state is PauseState:
		PauseManager.pause_menu.show()


func load_settings():
	var config = ConfigFile.new()
	
	if config.load("user://settings.cfg") != OK:
		return
	
	master_volume = config.get_value(
		"audio",
		"master",
		1.0
	)
	
	music_volume = config.get_value(
		"audio",
		"music",
		1.0
	)
	
	sfx_volume = config.get_value(
		"audio",
		"sfx",
		1.0
	)
	
	fullscreen = config.get_value(
		"graphics",
		"fullscreen",
		true
	)
	
	vsync = config.get_value(
		"graphics",
		"vsync",
		true
	)
	
	apply_settings()


func apply_settings():
	set_master_volume(master_volume)
	set_music_volume(music_volume)
	set_sfx_volume(sfx_volume)
	
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	if vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
