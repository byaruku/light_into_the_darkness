extends CanvasLayer

@onready var text_label = $TextureRect2/Label


func type_dialog(text: String) -> void:
	GameManager.state_machine.push(PauseState.new())
	
	text_label.text = ""

	for letter in text:
		text_label.text += letter

		await get_tree().create_timer(
			1.0 / 30
			#1.0 / GlobalSetting.i.letters_per_second
		).timeout
	
	GameManager.state_machine.pop()


func wait_for_accept() -> void:
	while true:
		await get_tree().process_frame

		if Input.is_action_just_pressed("jump"):
			return
