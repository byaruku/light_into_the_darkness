class_name FireflyManager
extends Node

@export var target_amount := 6

@onready var firefly_ui = $FireflyUI

var collected := 0


func _ready() -> void:
	for child in get_children():
		if child is Firefly:
			child.collected.connect(_on_firefly_collected)


func _on_firefly_collected(_firefly):
	collected += 1
	
	firefly_ui.add_firefly()
	
	if collected >= target_amount:
		self.queue_free()
