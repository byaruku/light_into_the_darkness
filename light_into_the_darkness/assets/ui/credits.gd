extends CanvasLayer

signal closed

@export var back_button: Button
@export var feedback_button: Button
@export var space_button: Button

@onready var buttons: Array[Button] = [back_button, feedback_button]


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
		back_button.text = "Zurück"
		feedback_button.text = "Feedback geben"
		space_button.text = "Zurück"
	else:
		back_button.text = "Back"
		feedback_button.text = "Give Feedback"
		space_button.text = "Back"


func show_credits():
	show()
	
	buttons[1].grab_focus()


func _on_back_button_pressed() -> void:
	closed.emit()
	hide()


func _on_feedback_button_pressed() -> void:
	OS.shell_open("https://easy-feedback.de/umfrage/2145281/9k505c9")
