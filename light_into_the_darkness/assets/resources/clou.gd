class_name Clou
extends Node2D

@export var data: ClouData

var collected := false


func _ready() -> void:
	$Sprite2D.texture = data.icon
	
	collected = data.clou_id in ClouManager.collected_clous
	
	if collected:
		hide()
		$Area2D.monitorable = false
