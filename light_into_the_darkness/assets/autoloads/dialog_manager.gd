extends Node

signal on_show_dialog
signal on_dialog_finished

@onready var dialog_box:= $DialogBox
@onready var choice_box:= $DialogBox/TextureRect2/HBoxContainer/Choices


func _ready() -> void:
	dialog_box.hide()

func show_dialog(dialog: Dialog) -> void:

	await get_tree().process_frame

	on_show_dialog.emit()

	dialog_box.show()

	for line in dialog.lines:
		#AudioManager.i.play_sfx(AudioID.UI_SELECT)
		dialog_box.set_speaker(line.speaker_name, line.portrait)

		await dialog_box.type_dialog(line.text)

		if line.choices.size() > 0:
			
			choice_box.show()
			choice_box.show_choices(line.choices)
			
			var selected = await choice_box.choice_selected
			var next_dialog = line.choices[selected].next_dialog
			
			choice_box.hide()
			
			if next_dialog:
				await show_dialog(next_dialog)
				
			break
		else:
			await dialog_box.wait_for_accept()

	if (dialog_box.visible == true):
		dialog_box.hide()
		on_dialog_finished.emit()
