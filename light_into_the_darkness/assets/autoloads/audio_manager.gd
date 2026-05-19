extends Node

@onready var music_player := AudioStreamPlayer.new()
@onready var sfx_player := AudioStreamPlayer.new()


func _ready():
	add_child(music_player)
	add_child(sfx_player)


func play_music(stream: AudioStream):
	music_player.stream = stream
	music_player.play()


func play_sfx(stream: AudioStream):
	sfx_player.stream = stream
	sfx_player.play()
