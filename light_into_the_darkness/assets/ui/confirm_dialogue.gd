extends CanvasLayer

signal confirmed(bool)

@onready var message_label = $Panel/MarginContainer/VBoxContainer/MessageLabel


func _ready() -> void:
	hide()


func ask(message: String):
	message_label.text = message
	show()
	$Panel/MarginContainer/VBoxContainer/HBoxContainer/CancelButton.grab_focus()


func _on_cancel_button_pressed() -> void:
	hide()
	confirmed.emit(false)


func _on_confirm_button_pressed() -> void:
	hide()
	confirmed.emit(true)
