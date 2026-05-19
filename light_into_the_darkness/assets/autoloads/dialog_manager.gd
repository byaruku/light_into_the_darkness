extends Node

signal on_show_dialog
signal on_dialog_finished

@onready var dialog_box: CanvasLayer = $DialogBox


func _ready() -> void:
	dialog_box.hide()

func show_dialog(
		dialog: Dialog,
		choices: Array[String] = [],
		on_choice_selected: Callable = Callable()
	) -> void:

	await get_tree().process_frame

	on_show_dialog.emit()

	dialog_box.show()

	for line in dialog.lines:
		#AudioManager.i.play_sfx(AudioID.UI_SELECT)

		await dialog_box.type_dialog(line)

		await dialog_box.wait_for_accept()

	#if choices.size() > 1:
		#ChoiceBoxState.i.choices = choices
#
		#await GameController.instance.state_machine.push_and_wait(
			#ChoiceBoxState.i
		#)
#
		#if on_choice_selected.is_valid():
			#on_choice_selected.call(
				#ChoiceBoxState.i.selected_choice
			#)

	dialog_box.hide()

	on_dialog_finished.emit()
