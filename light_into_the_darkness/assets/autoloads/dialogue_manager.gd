extends Node

signal on_show_dialog
signal on_dialog_finished

@onready var dialogue_runner: YarnDialogueRunner = $YarnDialogueRunner


func start_dialogue(node_name: String) -> void:
	on_show_dialog.emit()
	
	dialogue_runner.start_dialogue(node_name)

	await dialogue_runner.dialogue_completed
	
	on_dialog_finished.emit()
