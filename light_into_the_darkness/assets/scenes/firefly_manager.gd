class_name FireflyManager
extends Node

@export var target_amount := 6
@export var firefly_packed : PackedScene

@onready var spawn_area : SpawnArea = $SpawnArea
@onready var firefly_ui = $FireflyUI

var collected := 0


func _ready() -> void:
	DialogueManager.dialogue_runner.add_command("destroy_firefly_manager", destroy_self)
	
	for i in range(target_amount):
		var firefly = firefly_packed.instantiate()
		firefly.collected.connect(_on_firefly_collected)
		add_child(firefly)
		
		spawn_area.objects.append(firefly)
	
	spawn_area.spawn_objects()
	
	for child in get_children():
		if child is Firefly:
			child.start()

func _on_firefly_collected(_firefly):
	collected += 1
	
	IdentityManager.add_progress(2)
	
	firefly_ui.add_firefly()
	
	if collected >= target_amount:
		DialogueManager.start_dialogue("Way_Home")
		destroy_self()


func destroy_self() -> void:
	self.queue_free()
