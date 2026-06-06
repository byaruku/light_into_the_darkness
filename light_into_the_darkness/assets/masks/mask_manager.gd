class_name MaskManager
extends Node

enum MaskType {
	RAGE,
	JOY
}

signal mask_started(mask)
signal mask_ended(mask)

@export var masks: Array[MaskAbility]

var active_mask: MaskAbility
var player: Player


func use_mask(mask: MaskAbility):
	if active_mask or not can_use(mask):
		return
	
	active_mask = mask
	mask.activate(player)
	mask_started.emit(mask)
	
	await get_tree().create_timer(mask.duration).timeout
	
	mask.deactivate(player)
	mask_ended.emit(mask)
	active_mask = null


func get_mask(mask_type: MaskType) -> MaskAbility:
	for mask in masks:
		if mask.mask_type == mask_type:
			return mask
	return null


func can_use(mask: MaskAbility) -> bool:
	return GameManager.mask_charges[mask.mask_type] > 0 && active_mask == null


func add_charge(mask_type: MaskType, amount: int = 1):
	var mask = get_mask(mask_type)
	GameManager.mask_charges[mask.mask_type] += amount
	print(mask.mask_name, " ", GameManager.mask_charges[mask.mask_type])
