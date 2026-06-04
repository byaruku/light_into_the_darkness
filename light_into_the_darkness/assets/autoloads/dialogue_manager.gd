extends Node

signal on_show_dialog
signal on_dialog_finished

@onready var dialogue_runner: YarnDialogueRunner = $YarnDialogueRunner


func _ready() -> void:
	dialogue_runner.add_command("change_scene",change_scene)

func start_dialogue(node_name: String) -> void:
	on_show_dialog.emit()
	
	dialogue_runner.start_dialogue(node_name)
	
	await dialogue_runner.dialogue_completed
	
	on_dialog_finished.emit()


func change_scene(destination: String) -> void:
	match destination:
		"TOWN":
			SceneManager.change_scene(Portal.Destination.TOWN)
		"MEMORY_1":
			SceneManager.change_scene(Portal.Destination.MEMORY_1)
