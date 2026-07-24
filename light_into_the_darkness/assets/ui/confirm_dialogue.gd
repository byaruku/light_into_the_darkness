extends CanvasLayer

signal confirmed(bool)

@onready var message_label = $Panel/MarginContainer/VBoxContainer/MessageLabel
@onready var buttons: Array = [
	$Panel/MarginContainer/VBoxContainer/HBoxContainer/ConfirmButton,
	$Panel/MarginContainer/VBoxContainer/HBoxContainer/CancelButton
]

func _ready() -> void:
	hide()
	for button in buttons:
		button.focus_entered.connect(AudioManager.play_ui_hover)
		button.mouse_entered.connect(AudioManager.play_ui_hover)
		button.pressed.connect(AudioManager.play_ui_select)


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
