class_name MaskManager
extends Node

enum MaskType {
	RAGE,
	JOY
}

signal mask_started(mask)
signal mask_ended(mask)
signal charges_changed(mask_type, charges)

@export var masks: Array[MaskAbility]

var active_mask: MaskAbility
var active_mask_time_left := 0.0

var player: Player


func use_mask(mask: MaskAbility):
	if active_mask or not can_use(mask):
		return
	
	active_mask = mask
	active_mask_time_left = mask.duration
	
	GameManager.mask_charges[mask.mask_type] -= 1
	charges_changed.emit(mask.mask_type, GameManager.mask_charges[mask.mask_type])
	
	mask.activate(player)
	mask_started.emit(mask)
	
	while active_mask_time_left > 0:
		await get_tree().process_frame
		if GameManager.state_machine.current_state is FreeRoamState:
			active_mask_time_left -= get_process_delta_time()
	
	mask.deactivate(player)
	mask_ended.emit(mask)
	
	active_mask = null
	active_mask_time_left = 0.0


func get_mask(mask_type: MaskType) -> MaskAbility:
	for mask in masks:
		if mask.mask_type == mask_type:
			return mask
	return null


func can_use(mask: MaskAbility) -> bool:
	if not GameManager.is_in_memory:
		return false
	
	if active_mask:
		return false
	
	return GameManager.mask_charges[mask.mask_type] > 0


func add_charge(mask_type: MaskType, amount: int = 1):
	var mask = get_mask(mask_type)
	GameManager.mask_charges[mask.mask_type] += amount
	charges_changed.emit(mask_type, GameManager.mask_charges[mask.mask_type])
	print(mask.mask_name, " ", GameManager.mask_charges[mask.mask_type])


func force_end_mask():
	if active_mask == null:
		return
	
	active_mask.deactivate(player)
	mask_ended.emit(active_mask)
	active_mask = null
