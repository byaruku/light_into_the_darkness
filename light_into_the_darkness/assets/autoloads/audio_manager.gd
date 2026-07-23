extends Node

@export_category("Music")
@export var main_menu_music: AudioStream
@export var town_music: AudioStream
@export var memory_1_part_1_music: AudioStream
@export var memory_1_part_2_music: AudioStream
@export var memory_2_music: AudioStream
@export var memory_3_music: AudioStream

@export var fade_time := 2.0

@onready var current_player := $MusicPlayerA
@onready var inactive_player := $MusicPlayerB


func play_music_for(destination: Portal.Destination = , part: int = 1):
	match destination:
		Portal.Destination.TOWN:
			if part == 1:
				fade_to(town_music)
			else:
				fade_to(main_menu_music)
		Portal.Destination.MEMORY_1:
			if part == 1:
				fade_to(memory_1_part_1_music)
			else:
				fade_to(memory_1_part_2_music)
		Portal.Destination.MEMORY_2:
			fade_to(memory_2_music)
		Portal.Destination.MEMORY_3:
			fade_to(memory_3_music)


func fade_to(stream: AudioStream):
	if stream == null:
		return
	
	if current_player.playing and current_player.stream == stream:
		return
	
	if !current_player.playing:
		current_player.stream = stream
		current_player.volume_db = -70
		current_player.play()
		return
	
	inactive_player.stop()
	inactive_player.stream = stream
	inactive_player.volume_db = -110
	inactive_player.play()
	
	var tween = create_tween()
	
	tween.parallel().tween_property(
		current_player,
		"volume_db",
		-110,
		fade_time
	)
	tween.parallel().tween_property(
		inactive_player,
		"volume_db",
		-70,
		fade_time
	)
	
	await tween.finished
	
	current_player.stop()
	
	var temp = current_player
	current_player = inactive_player
	inactive_player = temp


func clear_data():
	current_player.stop()
	inactive_player.stop()
	current_player = $MusicPlayerA
	inactive_player = $MusicPlayerB
