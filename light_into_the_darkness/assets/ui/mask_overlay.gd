class_name MaskOverlay
extends CanvasLayer

@onready var animation_playback = $AnimationPlayer

@onready var rage_slot = $MarginContainer/HBoxContainer/RageSlot
@onready var joy_slot = $MarginContainer/HBoxContainer/JoySlot

var mask_manager : MaskManager
var last_warning_second := -1


func _ready() -> void:
	await get_tree().process_frame
	
	mask_manager = GameManager.player.mask_manager
	
	mask_manager.mask_started.connect(_on_mask_started)
	mask_manager.mask_ended.connect(_on_mask_ended)
	mask_manager.charges_changed.connect(_on_charges_changed)
	
	update_ui()


func _process(_delta: float) -> void:
	var enabled = GameManager.is_in_memory
	
	for mask in mask_manager.masks:
		var slot = get_slot(mask.mask_type)
		slot.modulate.a = 1.0 if enabled else 0.3
	
	check_mask_warning()


func update_ui():
	for mask in mask_manager.masks:
		var slot = get_slot(mask.mask_type)
		slot.set_charges(GameManager.mask_charges[mask.mask_type])


func get_slot(type):
	match type:
		MaskManager.MaskType.RAGE:
			return rage_slot
		MaskManager.MaskType.JOY:
			return joy_slot
	return null


func _on_mask_started(mask):
	rage_slot.set_active(false)
	joy_slot.set_active(false)
	get_slot(mask.mask_type).set_active(true)
	play_mask_pulse(mask.mask_type)


func play_mask_pulse(mask_type: MaskManager.MaskType):
	if mask_type == MaskManager.MaskType.RAGE:
		animation_playback.play("hannya_pulse")
	elif mask_type == MaskManager.MaskType.JOY:
		animation_playback.play("okame_pulse")


func _on_mask_ended(mask):
	get_slot(mask.mask_type).set_active(false)


func _on_charges_changed(mask_type, charges):
	var slot = get_slot(mask_type)
	slot.set_charges(charges)
	update_ui()


func check_mask_warning():
	if mask_manager.active_mask == null:
		last_warning_second = -1
		return
	
	var time_left = ceil(mask_manager.active_mask_time_left)
	
	if time_left > 3:
		last_warning_second = -1
		return
	
	if time_left != last_warning_second:
		last_warning_second = time_left
		play_mask_pulse(mask_manager.active_mask.mask_type)
