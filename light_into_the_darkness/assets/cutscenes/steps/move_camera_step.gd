class_name MoveCameraStep
extends CutsceneStep

@export var marker: NodePath
@export var duration := 1.5


func execute():
	var target = Engine.get_main_loop().current_scene.get_node(marker)
	
	await CameraManager.move_to(target.position, duration)
	
	CameraManager.resume_follow()
