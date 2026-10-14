extends CanvasLayer

signal confirmed(bool)

@export var message_label: RichTextLabel
@export var confirm_button: Button
@export var cancel_button: Button

@onready var buttons: Array = [
	confirm_button,
	cancel_button
]


func _ready() -> void:
	SettingsManager.change_language.connect(_on_language_change)
	_on_language_change()
	hide()
	for button in buttons:
		button.focus_entered.connect(AudioManager.play_ui_hover)
		button.mouse_entered.connect(AudioManager.play_ui_hover)
		button.pressed.connect(AudioManager.play_ui_select)


func _on_language_change() -> void:
	var current: String = DialogueManager.dialogue_runner.get_locale()
	if current == "de":
		confirm_button.text = "Ja"
		cancel_button.text = "Nein"
	else:
		confirm_button.text = "Yes"
		cancel_button.text = "No"


func ask(message: String):
	message_label.text = message
	show()
	cancel_button.grab_focus()


func _on_cancel_button_pressed() -> void:
	hide()
	confirmed.emit(false)


func _on_confirm_button_pressed() -> void:
	hide()
	confirmed.emit(true)
