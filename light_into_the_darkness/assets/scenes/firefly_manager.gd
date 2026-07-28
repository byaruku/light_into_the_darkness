class_name FireflyManager
extends Node

@export var target_amount := 6

@onready var firefly_ui = $FireflyUI

var collected := 0


func _ready() -> void:
	DialogueManager.dialogue_runner.add_command("destroy_firefly_manager", destroy_self)
	
	for child in get_children():
		if child is Firefly:
			child.collected.connect(_on_firefly_collected)


func _on_firefly_collected(_firefly):
	collected += 1
	
	firefly_ui.add_firefly()
	
	if collected >= target_amount:
		IdentityManager.add_progress(12)
		DialogueManager.start_dialogue("Way_Home")
		destroy_self()


func destroy_self() -> void:
	self.queue_free()
