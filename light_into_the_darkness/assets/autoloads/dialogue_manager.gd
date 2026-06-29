extends Node

signal on_show_dialog
signal on_dialog_finished

@export var portrait_sprite: Sprite2D

@onready var dialogue_runner: YarnDialogueRunner = $YarnDialogueRunner


func _ready() -> void:
	dialogue_runner.add_command("show_portrait", show_portrait)
	dialogue_runner.add_command("hide_portrait", hide_portrait)
	dialogue_runner.add_command("change_scene", change_scene)
	dialogue_runner.add_command("add_identity", add_identity)


func start_dialogue(node_name: String) -> void:
	on_show_dialog.emit()
	
	dialogue_runner.start_dialogue(node_name)
	
	await dialogue_runner.dialogue_completed
	await get_tree().create_timer(0.1).timeout
	
	on_dialog_finished.emit()


func set_portrait(texture: Texture2D):
	portrait_sprite.texture = texture


func show_portrait():
	portrait_sprite.show()


func hide_portrait():
	portrait_sprite.hide()


func change_scene(destination: String) -> void:
	SceneManager.change_scene(int(destination))


func add_identity(amount: String):
	IdentityManager.add_progress(int(amount))
