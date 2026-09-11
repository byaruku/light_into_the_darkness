extends Node

signal log_opened
signal log_closed
signal entries_changed

@export var log_ui_scene: PackedScene

var entries: Array[DialogLogEntry] = []
var log_ui: DialogLogUI
var is_open := false


func _ready() -> void:
	if log_ui_scene == null:
		push_warning("DialogLogManager: No log_ui_scene assigned.")
		return
	
	log_ui = log_ui_scene.instantiate()
	get_tree().root.add_child.call_deferred(log_ui)
	
	log_ui.closed.connect(close)
	log_ui.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dialog_log") and (GameManager.state_machine.current_state is FreeRoamState or GameManager.state_machine.current_state is DialogueState):
		toggle()
		get_viewport().set_input_as_handled()


func add_entry(speaker_name: String, text: String) -> void:
	if text.strip_edges().is_empty():
		return
	
	var entry := DialogLogEntry.new()
	entry.speaker_name = speaker_name
	entry.text = text
	
	entries.append(entry)
	
	entries_changed.emit()
	
	if is_open and log_ui:
		log_ui.refresh(entries)
		await get_tree().process_frame
		log_ui.scroll_to_bottom()


func toggle() -> void:
	if is_open:
		close()
	else:
		open()


func open() -> void:
	if log_ui == null:
		return
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	is_open = true
	log_ui.show_log(entries)
	log_ui.scroll_to_bottom()
	log_opened.emit()


func close() -> void:
	if log_ui == null:
		return
	
	if GameManager.state_machine.current_state is not DialogueState:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	is_open = false
	log_ui.hide()
	log_closed.emit()


func clear() -> void:
	entries.clear()
	entries_changed.emit()
	
	if is_open and log_ui:
		log_ui.refresh(entries)
