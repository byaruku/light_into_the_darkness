extends Node

@export var pause_menu_scene: PackedScene
@export var confirm_dialog_scene: PackedScene

var pause_menu
var confirm_dialog
var is_open := false


func _ready() -> void:
	pause_menu = pause_menu_scene.instantiate()
	confirm_dialog = confirm_dialog_scene.instantiate()
	
	get_tree().root.add_child.call_deferred(pause_menu)
	get_tree().root.add_child.call_deferred(confirm_dialog)
	
	pause_menu.resume_pressed.connect(resume)
	pause_menu.main_menu_pressed.connect(return_main_menu)
	pause_menu.leave_memory_pressed.connect(leave_memory)


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
		"Diese Erinnerung wird verblassen. Du kannst nicht zu ihr zurückkehren."
	):
		resume()
		SceneManager.leave_memory()
	else:
		pause_menu.buttons[2].grab_focus()


func ask_confirmation(message: String) -> bool:
	confirm_dialog.ask(message)
	
	var result = await confirm_dialog.confirmed
	
	return result
