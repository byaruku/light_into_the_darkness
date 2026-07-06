extends Node

func play(track: CutsceneTrack):
	GameManager.state_machine.push(CutsceneState.new())
	
	for step in track.steps:
		await step.execute()
	
	GameManager.state_machine.pop()
