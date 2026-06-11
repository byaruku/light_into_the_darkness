extends Node

var state_machine : StateMachine

var player: Player

var is_in_memory := false

var mask_charges := {
	MaskManager.MaskType.RAGE: 1,
	MaskManager.MaskType.JOY: 1
}

func  _ready() -> void:
	state_machine = StateMachine.new(self)
	
	DialogueManager.on_show_dialog.connect(
		func():
			state_machine.push(DialogueState.new())
	)
	
	DialogueManager.on_dialog_finished.connect(
		func():
			state_machine.pop()
	)
	
	DialogueManager.dialogue_runner.add_command("add_charge", add_mask_charge)


func _process(delta: float) -> void:
	state_machine.execute(delta)


func clear_data():
	mask_charges = {
		MaskManager.MaskType.RAGE: 1,
		MaskManager.MaskType.JOY: 1
	}
	ClouManager.clear_data()
	IdentityManager.clear_data()

func leave_memory():
	GameManager.player.mask_manager.force_end_mask()
	SceneManager.change_scene(Portal.Destination.TOWN)


func add_mask_charge(mask_type: String):
	player.mask_manager.add_charge(int(mask_type))
