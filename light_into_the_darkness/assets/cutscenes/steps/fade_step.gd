class_name FadeStep
extends CutsceneStep


enum FadeType{
	IN,
	OUT
}


@export var fade := FadeType.OUT
@export var duration := 1.0


func execute():
	match fade:
		FadeType.IN:
			await Fader.fade_in(duration)
		FadeType.OUT:
			await Fader.fade_out(duration)
