extends Node

signal clear_mask_data

var state_machine : StateMachine

var player: Player

var player_position : Vector2
var is_in_memory := false
var tutorial_finished := false

var masks: Array[MaskAbility]

var mask_charges := {
	MaskManager.MaskType.RAGE: 0,
	MaskManager.MaskType.JOY: 0
}

var memory_completed := {
	Portal.Destination.TOWN: false,
	Portal.Destination.MEMORY_1: false,
	Portal.Destination.MEMORY_2: false,
	Portal.Destination.MEMORY_3: false
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
	player = null
	is_in_memory = false
	tutorial_finished = false
	masks = []
	mask_charges = {
		MaskManager.MaskType.RAGE: 0,
		MaskManager.MaskType.JOY: 0
	}
	memory_completed = {
		Portal.Destination.TOWN: false,
		Portal.Destination.MEMORY_1: false,
		Portal.Destination.MEMORY_2: false,
		Portal.Destination.MEMORY_3: false
	}
	player_position = Vector2.ZERO
	AudioManager.clear_data()
	ClouManager.clear_data()
	clear_mask_data.emit()
	IdentityManager.clear_data()


func leave_memory():
	GameManager.player.mask_manager.force_end_mask()
	SceneManager.change_scene(Portal.Destination.TOWN)


func add_mask_charge(mask_type: String):
	player.mask_manager.add_charge(int(mask_type))
