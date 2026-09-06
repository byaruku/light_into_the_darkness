extends TextureProgressBar


func _ready():
	max_value = IdentityManager.max_identity
	
	IdentityManager.identity_changed.connect(
		update_bar
	)
	
	update_bar(IdentityManager.current_identity)


func update_bar(current):
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "value", current, 1)
	await tween.finished
	
	value = current
