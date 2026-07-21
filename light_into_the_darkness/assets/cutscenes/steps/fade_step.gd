class_name FadeStep
extends CutsceneStep

enum FadeType{
	IN,
	OUT
}

@export var fade := FadeType.OUT


func execute():
	match fade:
		FadeType.IN:
			await Fader.fade_in()
		FadeType.OUT:
			await Fader.fade_out()
