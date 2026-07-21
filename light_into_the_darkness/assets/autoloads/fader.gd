extends CanvasLayer

@onready var sprite := $Sprite2D
@onready var animation_player := $AnimationPlayer


func _ready() -> void:
	sprite.hide()
	fade_out()

func fade_in():
	sprite.show()
	
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, 1.9)
	animation_player.play("portal_open")
	await tween.finished


func fade_out():
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 1.9)
	animation_player.play("portal_close")
	await tween.finished
	
	sprite.hide()
