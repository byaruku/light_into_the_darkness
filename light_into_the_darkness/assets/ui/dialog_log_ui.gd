class_name DialogLogUI
extends CanvasLayer

signal closed

@onready var entries_container: VBoxContainer = $TextureRect/MarginContainer/Panel/EntiresContainer


func _ready() -> void:
	hide()


func show_log(entries: Array[DialogLogEntry]) -> void:
	show()
	refresh(entries)


func refresh(entries: Array[DialogLogEntry]) -> void:
	for child in entries_container.get_children():
		child.queue_free()
	
	for entry in entries:
		var label := RichTextLabel.new()
		label.fit_content = true
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.bbcode_enabled = true
		label.push_font_size(4)
		
		var speaker := entry.speaker_name
		if speaker.strip_edges().is_empty():
			speaker = "Erzähler"
		
		var prefix := "[b]%s[/b]\n" % speaker
		if entry.is_choice:
			prefix = "[color=khaki][b]%s[/b][/color]\n" % speaker
		
		label.append_text(prefix + entry.text)
		entries_container.add_child(label)


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("dialog_log") or event.is_action_pressed("ui_cancel"):
		hide()
		closed.emit()
		get_viewport().set_input_as_handled()
