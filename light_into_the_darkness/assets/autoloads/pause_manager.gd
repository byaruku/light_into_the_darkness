extends Node

@export var pause_menu_scene: PackedScene
@export var confirm_dialog_scene: PackedScene
@export var settings_menu_scene: PackedScene

var pause_menu
var confirm_dialog
var settings_menu
var is_open := false


func _ready() -> void:
	pause_menu = pause_menu_scene.instantiate()
	confirm_dialog = confirm_dialog_scene.instantiate()
	settings_menu = settings_menu_scene.instantiate()
	
	get_tree().root.add_child.call_deferred(pause_menu)
	get_tree().root.add_child.call_deferred(confirm_dialog)
	get_tree().root.add_child.call_deferred(settings_menu)
	
	pause_menu.resume_pressed.connect(resume)
	pause_menu.settings_pressed.connect(settings)
	pause_menu.main_menu_pressed.connect(return_main_menu)
	pause_menu.leave_memory_pressed.connect(leave_memory)
	
	settings_menu.closed.connect(_on_settings_closed)


func toggle_pause():
	if is_open:
		resume()
	else:
		pause()


func pause():
	if GameManager.state_machine.current_state is DialogueState:
		return
	
	is_open = true
	GameManager.state_machine.push(PauseState.new())
	pause_menu.show_menu()


func resume():
	is_open = false
	pause_menu.hide()
	GameManager.state_machine.pop()


func settings():
	pause_menu.hide()
	settings_menu.show_menu()


func return_main_menu():
	if await ask_confirmation(
		"Dein Fortschritt geht verloren."
	):
		resume()
		if GameManager.state_machine.current_state is FreeRoamState:
			GameManager.state_machine.pop()
		SceneManager.return_to_main_menu()
	else:
		pause_menu.buttons[3].grab_focus()


func leave_memory():
	if await ask_confirmation(
		"Diese Welt wird verblassen. Du kannst nicht zu ihr zurückkehren."
	):
		resume()
		SceneManager.leave_memory()
	else:
		pause_menu.buttons[2].grab_focus()


func ask_confirmation(message: String) -> bool:
	confirm_dialog.ask(message)
	
	var result = await confirm_dialog.confirmed
	
	return result


func _on_settings_closed():
	if is_open:
		pause_menu.show()
		pause_menu.buttons[1].grab_focus()
