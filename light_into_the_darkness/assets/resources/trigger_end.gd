extends TriggerArea

@export var yarn: String

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var identity_procent = int(float(IdentityManager.current_identity) / float(IdentityManager.max_identity) * 100.0)
		DialogueManager.dialogue_runner.variable_storage.set_value("$identity", identity_procent)
		
		await super._on_body_entered(body)
		 
		await get_tree().create_timer(2).timeout
		
		var tween = create_tween()
		tween.tween_property(get_parent(), "modulate:a", 0.0, 1.0)
		await tween.finished
		
		IdentityManager.show_progress(true)
		
		if yarn != "":
			DialogueManager.start_dialogue(yarn)
			await DialogueManager.on_dialog_finished
		
		await get_tree().create_timer(2).timeout
		
		if GameManager.state_machine.current_state is FreeRoamState:
			GameManager.state_machine.pop()
		
		SceneManager.return_to_main_menu()
