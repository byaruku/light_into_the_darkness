class_name MoveCameraStep
extends CutsceneStep

@export var marker: NodePath
@export var duration := 1.5


func execute():
	var target = SceneManager.current_scene.get_node_or_null(marker)
	
	if target == null:
		push_error("MoveCameraStep: Marker not found.")
		return
	
	await CameraManager.move_to(target.global_position, duration)
	
	CameraManager.resume_follow()
