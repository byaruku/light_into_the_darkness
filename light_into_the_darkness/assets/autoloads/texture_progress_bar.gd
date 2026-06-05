extends TextureProgressBar


func _ready():
	max_value = IdentityManager.max_identity
	
	IdentityManager.identity_changed.connect(
		update_bar
	)
	
	update_bar(
		IdentityManager.current_identity,
		IdentityManager.max_identity
	)


func update_bar(current, maximum):
	max_value = maximum
	value = current
