extends Node

@export var main_menu_packed: PackedScene
@export var game_scene_packed: PackedScene

@export_file("*.tscn") var town_scene: String
@export_file("*.tscn") var memory_1_scene: String

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


func return_to_main_menu():
	await Fader.fade_in(0.5)
	
	if current_scene:
		current_scene.queue_free()

	GameManager.player = null
	GameManager.clear_data()
	load_main_menu()
	
	await Fader.fade_out(0.5)


func load_main_menu():
	GameManager.state_machine.push(MainMenuState.new())
	
	main_menu = main_menu_packed.instantiate()
	
	main_menu.new_game_pressed.connect(new_game)
	main_menu.settings_pressed.connect(settings_open)
	main_menu.about_pressed.connect(about_open)
	main_menu.exit_pressed.connect(exit_game)
	
	current_scene_container.add_child(main_menu)
	main_menu.show_menu()


func new_game():
	GameManager.state_machine.pop()
	main_menu.queue_free()
	
	current_scene = game_scene_packed.instantiate()
	current_scene_container.add_child(current_scene)
	current_scene_destination = Portal.Destination.TOWN
	GameManager.state_machine.push(FreeRoamState.new())


func settings_open():
	PauseManager.settings()


func about_open():
	pass


func exit_game():
	get_tree().quit()


func change_scene(destination: Portal.Destination):
	GameManager.state_machine.push(PauseState.new())
	
	await Fader.fade_in(1.0)
	
	if current_scene:
		previous_scene_destination = current_scene_destination
		current_scene.queue_free()
	
	var packed = load(scene_paths[destination])
	current_scene = packed.instantiate()
	current_scene_container.add_child(current_scene)
	current_scene_destination = destination

	await get_tree().process_frame
	await get_tree().process_frame

	var portal = find_destination_portal(destination)

	if portal:
		GameManager.player.global_position = (portal.spawn_marker.global_position)

	GameManager.is_in_memory = destination > 0

	await Fader.fade_out(1.0)

	GameManager.state_machine.pop()


func find_destination_portal(destination: Portal.Destination):
	var portals = get_tree().get_nodes_in_group("portals")

	for portal in portals:
		if portal.target_portal_id == destination:
			return portal

	return null


func leave_memory():
	change_scene(previous_scene_destination)
