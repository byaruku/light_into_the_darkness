class_name ChoiceBox
extends VBoxContainer

signal choice_selected(index)

@export var slot_scene: PackedScene

var choices: Array[DialogChoice] = []
var slots: Array[ChoiceSlot] = []
var selected_index := 0
var active := false


func _ready() -> void:
	clear_slots()


func show_choices(new_choices: Array[DialogChoice]):
	active = true
	choices = new_choices
	selected_index = 0
	
	clear_slots()
	
	for choice in choices:
		var slot = slot_scene.instantiate()
		self.add_child(slot)
		slot.set_text(choice.text)
		slots.append(slot)
	
	update_selection()


func clear_slots():
	for child in self.get_children():
		child.queue_free()

	slots.clear()

func update_selection():
	for i in slots.size():
		slots[i].set_selected(i == selected_index)


func _process(_delta):
	if not active:
		return

	if Input.is_action_just_pressed("down"):
		selected_index += 1

	if Input.is_action_just_pressed("up"):
		selected_index -= 1

	selected_index = clamp(selected_index, 0, choices.size() - 1)

	update_selection()

	if Input.is_action_just_pressed("jump"):
		choice_selected.emit(selected_index)
		clear_slots()
		active = false
		hide()
