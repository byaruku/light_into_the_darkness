class_name DialogLogUI
extends CanvasLayer

signal closed

@onready var entries_container: VBoxContainer = $Dimmer/TextureRect/MarginContainer/Panel/EntiresContainer
@onready var scroll_container: ScrollContainer = $Dimmer/TextureRect/MarginContainer/Panel


func _ready() -> void:
	hide()


func show_log(entries: Array[DialogLogEntry]) -> void:
	refresh(entries)
	await get_tree().process_frame
	scroll_to_bottom()
	show()


func refresh(entries: Array[DialogLogEntry]) -> void:
	for child in entries_container.get_children():
		child.queue_free()
	
	for entry in entries:
		var label := RichTextLabel.new()
		label.fit_content = true
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.bbcode_enabled = true
		label.push_font_size(4)
		
		var speaker := entry.speaker_name.strip_edges()
		if speaker.is_empty():
			speaker = "Erzähler"
		
		label.append_text("[b]%s[/b]\n%s" % [speaker, entry.text])
		entries_container.add_child(label)


func scroll_to_bottom() -> void:
	scroll_container.scroll_vertical = int(scroll_container.get_v_scroll_bar().max_value)


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("dialog_log") or event.is_action_pressed("ui_cancel"):
		hide()
		closed.emit()
		get_viewport().set_input_as_handled()
