extends Node

signal on_show_dialog
signal on_dialog_finished

@onready var dialogue_runner: YarnDialogueRunner = $YarnDialogueRunner


func _ready() -> void:
	dialogue_runner.add_command("change_scene", change_scene)
	dialogue_runner.add_command("add_identity", add_identity)


func start_dialogue(node_name: String) -> void:
	on_show_dialog.emit()
	
	dialogue_runner.start_dialogue(node_name)
	
	await dialogue_runner.dialogue_completed
	await get_tree().create_timer(0.1).timeout
	
	on_dialog_finished.emit()


func change_scene(destination: String) -> void:
	SceneManager.change_scene(int(destination))


func add_identity(amount: String):
	IdentityManager.add_progress(int(amount))
