extends Node

@export var main_menu_packed: PackedScene

@export_file("*.tscn") var town_scene: String
@export_file("*.tscn") var memory_1_scene: String
@export_file("*.tscn") var memory_2_scene: String
@export_file("*.tscn") var memory_3_scene: String
@export_file("*.tscn") var end_scene: String

@export var center_view: Vector2 = Vector2(80, 72)

@onready var current_scene_container = $CurrentSceneContainer

var main_menu
var current_scene

var previous_scene_destination: Portal.Destination
var current_scene_destination: Portal.Destination

var scene_paths := {}


func _ready():
	load_main_menu()
	scene_paths[Portal.Destination.TOWN] = town_scene
	scene_paths[Portal.Destination.MEMORY_1] = memory_1_scene
	scene_paths[Portal.Destination.MEMORY_2] = memory_2_scene
	scene_paths[Portal.Destination.MEMORY_3] = memory_3_scene
	scene_paths[Portal.Destination.END] = end_scene


func return_to_main_menu():
	GameManager.state_machine.push(PauseState.new())
	await Fader.fade_in()
	
	if current_scene:
		current_scene.queue_free()
	
	GameManager.state_machine.pop()
	GameManager.clear_data()
	load_main_menu()
	
	await Fader.fade_out()


func load_main_menu():
	GameManager.state_machine.push(MainMenuState.new())
	AudioManager.play_music_for(Portal.Destination.TOWN, 0)
	
	CameraManager.switch_to(center_view)
	
	main_menu = main_menu_packed.instantiate()
	
	main_menu.new_game_pressed.connect(new_game)
	main_menu.settings_pressed.connect(settings_open)
	main_menu.exit_pressed.connect(exit_game)
	
	current_scene_container.add_child(main_menu)
	main_menu.show_menu()


func new_game():
	await Fader.fade_in()
	
	GameManager.state_machine.pop()
	if current_scene_container.get_children().size() != 0:
		main_menu.queue_free()
	
	GameManager.state_machine.push(FreeRoamState.new())
	change_scene(Portal.Destination.TOWN)


func settings_open():
	PauseManager.settings()


func exit_game():
	get_tree().quit()


func change_scene(destination: Portal.Destination):
	GameManager.state_machine.push(PauseState.new())
	
	await Fader.fade_in()
	
	AudioManager.play_music_for(destination)
	
	if PauseManager.is_open:
		PauseManager.resume()
	
	if current_scene:
		previous_scene_destination = current_scene_destination
		current_scene.queue_free()
		if current_scene_destination > 0:
			GameManager.memory_completed[current_scene_destination] = true
			if current_scene_destination == Portal.Destination.MEMORY_1:
				GameManager.memory_completed[Portal.Destination.TOWN] = true
			elif current_scene_destination == Portal.Destination.MEMORY_3:
				destination = Portal.Destination.END
		current_scene = null
		
	var path = scene_paths[destination]
	ResourceLoader.load_threaded_request(path)
	
	while ResourceLoader.load_threaded_get_status(path) != ResourceLoader.THREAD_LOAD_LOADED:
		await get_tree().process_frame
	
	var packed: PackedScene = ResourceLoader.load_threaded_get(path)
	current_scene = packed.instantiate()
	current_scene_container.add_child(current_scene)
	current_scene_destination = destination

	var portal = find_destination_portal(destination)

	if portal:
		GameManager.player.global_position = portal.spawn_marker.global_position

	GameManager.is_in_memory = destination > 0
	
	if not GameManager.is_in_memory and GameManager.player_position != Vector2.ZERO:
		GameManager.player.global_position = GameManager.player_position
	
	CameraManager.switch_to(GameManager.player.global_position)
	CameraManager.follow_node(GameManager.player)

	await Fader.fade_out()
	
	GameManager.state_machine.pop()


func find_destination_portal(destination: Portal.Destination):
	for portal in get_tree().get_nodes_in_group("portals"):
		if portal.portal_id == destination:
			return portal

	return null


func leave_memory():
	change_scene(previous_scene_destination)
