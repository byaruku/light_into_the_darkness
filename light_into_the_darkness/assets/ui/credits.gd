extends CanvasLayer

signal closed

@onready var back_button: Button = $Control/MarginContainer/VBoxContainer/HBoxContainer2/BackButton
@onready var feedback_button: Button = $Control/MarginContainer/VBoxContainer/HBoxContainer2/FeedbackButton

var buttons: Array[Button]

func _ready() -> void:
	hide()
	buttons = [back_button, feedback_button]
	for button in buttons:
		button.focus_entered.connect(AudioManager.play_ui_hover)
		button.mouse_entered.connect(AudioManager.play_ui_hover)
		button.pressed.connect(AudioManager.play_ui_select)


func show_credits():
	show()
	
	buttons[1].grab_focus()


func _on_back_button_pressed() -> void:
	closed.emit()
	hide()


func _on_feedback_button_pressed() -> void:
	OS.shell_open("https://easy-feedback.de/umfrage/2145281/9k505c9")
