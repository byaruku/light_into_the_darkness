extends Node

var state_machine : StateMachine

var player: Player
var current_scene


func  _ready() -> void:
	state_machine = StateMachine.new(self)
	state_machine.change_state(FreeRoamState.new())
	
	DialogManager.on_show_dialog.connect(
		func():
			state_machine.push(DialogState.new())
	)
	
	DialogManager.on_dialog_finished.connect(
		func():
			state_machine.pop()
	)


func _process(delta: float) -> void:
	state_machine.execute(delta)
