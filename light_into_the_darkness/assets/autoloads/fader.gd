extends CanvasLayer

@onready var rect = $ColorRect


func _ready() -> void:
	fade_out(0)

func fade_in(time: float):
	rect.show()
	var tween = create_tween()

	tween.tween_property(rect, "modulate:a", 1.0, time)

	await tween.finished


func fade_out(time: float):
	var tween = create_tween()

	tween.tween_property(rect, "modulate:a", 0.0, time)

	await tween.finished
	rect.hide()
