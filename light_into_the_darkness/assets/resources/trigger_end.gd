extends TriggerArea


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var identity_procent = int(float(IdentityManager.current_identity) / float(IdentityManager.max_identity) * 100.0)
		DialogueManager.dialogue_runner.variable_storage.set_value("$identity", identity_procent)
		
		await super._on_body_entered(body)
		 
		if GameManager.state_machine.current_state is FreeRoamState:
			GameManager.state_machine.pop()
		
		await get_tree().create_timer(2).timeout
		SceneManager.return_to_main_menu()
