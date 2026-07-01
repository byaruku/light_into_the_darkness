class_name MovePlayerStep
extends CutsceneStep

@export var target_marker: NodePath

func execute():
	var player = GameManager.player
	
	var marker = SceneManager.current_scene.get_node_or_null(target_marker)
	
	if marker == null:
		push_error("MovePlayerStep: Marker not found.")
		return
	
	await player.cutscene_walk_to(marker.global_position)
