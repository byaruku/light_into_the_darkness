class_name MaskOverlay
extends CanvasLayer

@onready var pulse = $Pulse

@onready var rage_slot = $MarginContainer/HBoxContainer/RageSlot
@onready var joy_slot = $MarginContainer/HBoxContainer/JoySlot

var mask_manager : MaskManager


func _ready() -> void:
	await get_tree().process_frame
	
	pulse.modulate.a = 0
	
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
	play_mask_pulse()


func play_mask_pulse():
	var tween = create_tween()
	
	pulse.modulate.a = 0.5
	
	tween.tween_property(pulse, "modulate:a", 0.0, 0.4)


func _on_mask_ended(mask):
	get_slot(mask.mask_type).set_active(false)


func _on_charges_changed(mask_type, charges):
	var slot = get_slot(mask_type)
	slot.set_charges(charges)
	update_ui()
