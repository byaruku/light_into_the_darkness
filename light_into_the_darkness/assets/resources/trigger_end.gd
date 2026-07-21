extends TriggerArea


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hide()
		DialogueManager.dialogue_runner.variable_storage.set_value("identity", IdentityManager.current_identity)
		await super._on_body_entered(body)
		if GameManager.state_machine.current_state is FreeRoamState:
			GameManager.state_machine.pop()
		SceneManager.return_to_main_menu()
