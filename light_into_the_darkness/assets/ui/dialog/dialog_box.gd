extends CanvasLayer

@onready var portrait_rect = $TextureRect2/HBoxContainer/SpeakerInfo/TextureRect
@onready var name_label = $TextureRect2/HBoxContainer/SpeakerInfo/Label
@onready var text_label = $TextureRect2/HBoxContainer/TextLabel


func set_speaker(name_string: String, portrait: Texture2D):
	name_label.text = name_string
	portrait_rect.texture = portrait


func type_dialog(text: String) -> void:
	GameManager.state_machine.push(PauseState.new())
	
	text_label.text = ""

	for letter in text:
		text_label.text += letter

		await get_tree().create_timer(
			1.0 / 60
		).timeout
	
	GameManager.state_machine.pop()


func wait_for_accept() -> void:
	while true:
		await get_tree().process_frame
		
		if Input.is_action_just_pressed("jump"):
			return
